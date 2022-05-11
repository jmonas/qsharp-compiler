﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using LlvmBindings.Values;
using Microsoft.Quantum.QsCompiler.QIR;
using Microsoft.Quantum.QsCompiler.SyntaxTokens;
using Microsoft.Quantum.QsCompiler.SyntaxTree;

namespace Microsoft.Quantum.QIR.Emission
{
    using ResolvedTypeKind = QsTypeKind<ResolvedType, UserDefinedType, QsTypeParameter, CallableInformation>;

    /// <summary>
    /// Each class instance contains permits to construct QIR values for use
    /// within the compilation unit given upon instantiation.
    /// </summary>
    internal class QirValues
    {
        private readonly GenerationContext sharedState;

        internal IValue Unit { get; }

        internal QirValues(GenerationContext context, Constants constants)
        {
            this.sharedState = context;
            this.Unit = new SimpleValue(constants.UnitValue, ResolvedType.New(ResolvedTypeKind.UnitType));
        }

        public static uint? AsConstantInt(Value? value) =>
            value is ConstantInt count && count.ZeroExtendedValue < int.MaxValue ? (uint?)count.ZeroExtendedValue : null;

        internal IValue DefaultValue(ResolvedType type)
        {
            if (type.Resolution.IsInt)
            {
                var value = this.sharedState.Context.CreateConstant(0L);
                return this.sharedState.Values.FromSimpleValue(value, type);
            }
            else if (type.Resolution.IsDouble)
            {
                var value = this.sharedState.Context.CreateConstant(0.0);
                return this.sharedState.Values.FromSimpleValue(value, type);
            }
            else if (type.Resolution.IsBool)
            {
                var value = this.sharedState.Context.CreateConstant(false);
                return this.sharedState.Values.FromSimpleValue(value, type);
            }
            else if (type.Resolution.IsPauli)
            {
                var pointer = this.sharedState.Constants.PauliI;
                var constant = this.sharedState.CurrentBuilder.Load(this.sharedState.Types.Pauli, pointer);
                return this.sharedState.Values.From(constant, type);
            }
            else if (type.Resolution.IsResult)
            {
                var getZero = this.sharedState.GetOrCreateRuntimeFunction(RuntimeLibrary.ResultGetZero);
                var constant = this.sharedState.CurrentBuilder.Call(getZero);
                return this.sharedState.Values.From(constant, type);
            }
            else if (type.Resolution.IsQubit)
            {
                var value = Constant.ConstPointerToNullFor(this.sharedState.Types.Qubit);
                return this.sharedState.Values.From(value, type);
            }
            else if (type.Resolution.IsRange)
            {
                var pointer = this.sharedState.Constants.EmptyRange;
                var constant = this.sharedState.CurrentBuilder.Load(this.sharedState.Types.Range, pointer);
                return this.sharedState.Values.From(constant, type);
            }
            else if (type.Resolution is ResolvedTypeKind.TupleType ts)
            {
                var values = ts.Item.Select(this.DefaultValue).ToArray();
                return this.sharedState.Values.CreateTuple(values, allocOnStack: this.sharedState.TargetQirProfile);
            }
            else if (type.Resolution is ResolvedTypeKind.UserDefinedType udt)
            {
                var elementTypes = this.sharedState.GetItemTypes(udt.Item.GetFullName());
                var values = elementTypes.Select(this.DefaultValue).ToArray();
                return this.sharedState.Values.CreateCustomType(udt.Item.GetFullName(), values, allocOnStack: this.sharedState.TargetQirProfile);
            }

            if (type.Resolution is ResolvedTypeKind.ArrayType itemType)
            {
                return this.sharedState.Values.CreateArray(itemType.Item, Array.Empty<IValue>(), allocOnStack: this.sharedState.TargetQirProfile);
            }
            else if (type.Resolution.IsFunction || type.Resolution.IsOperation)
            {
                // We can't simply set this to null, unless the reference and alias counting functions
                // in the runtime accept null values as arguments.
                var nullTableName = $"DefaultCallable__NullFunctionTable";
                var nullTable = this.sharedState.Module.GetNamedGlobal(nullTableName);
                if (nullTable == null)
                {
                    var fctType = this.sharedState.Types.FunctionSignature.CreatePointerType();
                    var funcs = Enumerable.Repeat(Constant.ConstPointerToNullFor(fctType), 4);
                    var array = ConstantArray.From(fctType, funcs.ToArray());
                    nullTable = this.sharedState.Module.AddGlobal(array.NativeType, true, Linkage.Internal, array, nullTableName);
                }

                var createCallable = this.sharedState.GetOrCreateRuntimeFunction(RuntimeLibrary.CallableCreate);
                var memoryManagementTable = this.sharedState.GetOrCreateCallableMemoryManagementTable(null);
                var value = this.sharedState.CurrentBuilder.Call(createCallable, nullTable, memoryManagementTable, this.sharedState.Constants.UnitValue);
                var built = this.sharedState.Values.FromCallable(value, type);
                this.sharedState.ScopeMgr.RegisterValue(built);
                return built;
            }
            else if (type.Resolution.IsString)
            {
                return QirExpressionKindTransformation.CreateStringLiteral(this.sharedState, "");
            }
            else if (type.Resolution.IsBigInt)
            {
                var value = this.sharedState.CurrentBuilder.Call(
                    this.sharedState.GetOrCreateRuntimeFunction(RuntimeLibrary.BigIntCreateI64),
                    this.sharedState.Context.CreateConstant(0L));
                var built = this.sharedState.Values.From(value, type);
                this.sharedState.ScopeMgr.RegisterValue(built);
                return built;
            }
            else if (type.Resolution.IsUnitType)
            {
                return this.sharedState.Values.Unit;
            }
            else
            {
                throw new NotSupportedException("no known default value for the given type");
            }
        }

        /// <summary>
        /// Creates a simple value that stores the given LLVM value as well as its Q# type.
        /// </summary>
        /// <param name="value">The LLVM value to store</param>
        /// <param name="type">The Q# of the value</param>
        internal SimpleValue FromSimpleValue(Value value, ResolvedType type) =>
            new SimpleValue(value, type);

        /// <summary>
        /// Creates a tuple value that stores the given LLVM value representing a Q# value of user defined type.
        /// </summary>
        /// <param name="value">The typed tuple representing a value of user defined type</param>
        /// <param name="typeName">The Q# type name of the value</param>
        internal TupleValue FromCustomType(Value value, QsQualifiedName typeName) =>
            new TupleValue(typeName, value, this.sharedState.GetItemTypes(typeName), this.sharedState);

        /// <summary>
        /// Creates a new tuple value from the given tuple pointer. The casts to get the opaque and typed pointer
        /// respectively are executed lazily. When needed, instructions are emitted using the current builder.
        /// </summary>
        /// <param name="tuple">Either an opaque or a typed pointer to the tuple data structure</param>
        /// <param name="elementTypes">The Q# types of the tuple items</param>
        internal TupleValue FromTuple(Value tuple, ImmutableArray<ResolvedType> elementTypes) =>
            new TupleValue(tuple, elementTypes, this.sharedState);

        /// <summary>
        /// Creates a new array value from the given opaque array of elements of the given type.
        /// </summary>
        /// <param name="elementType">Q# type of the array elements</param>
        internal ArrayValue FromArray(Value value, ResolvedType elementType, uint? count) =>
            new ArrayValue(value, elementType, count, this.sharedState);

        /// <summary>
        /// Creates a callable value that stores the given LLVM value representing a Q# callable.
        /// </summary>
        /// <param name="value">The LLVM value to store</param>
        /// <param name="type">The Q# of the value</param>
        internal CallableValue FromCallable(Value value, ResolvedType type) =>
            new CallableValue(value, type, this.sharedState);

        /// <summary>
        /// Creates a suitable class to pass around a built LLVM value that represents a Q# value of the given type.
        /// </summary>
        /// <param name="value">The LLVM value to store</param>
        /// <param name="type">The Q# of the value</param>
        internal IValue From(Value value, ResolvedType type) =>
            type.Resolution is ResolvedTypeKind.ArrayType it ? this.sharedState.Values.FromArray(value, it.Item, null) :
            type.Resolution is ResolvedTypeKind.TupleType ts ? this.sharedState.Values.FromTuple(value, ts.Item) :
            type.Resolution is ResolvedTypeKind.UserDefinedType udt ? this.sharedState.Values.FromCustomType(value, udt.Item.GetFullName()) :
            (type.Resolution.IsOperation || type.Resolution.IsFunction) ? this.sharedState.Values.FromCallable(value, type) :
            (IValue)new SimpleValue(value, type);

        /// <summary>
        /// Creates a pointer to the given value.
        /// When needed, instructions are emitted using the current builder.
        /// </summary>
        /// <param name="value">The value that the pointer points to</param>
        internal PointerValue CreatePointer(IValue value) =>
            new PointerValue(value, this.sharedState);

        /// <summary>
        /// Creates a new tuple value. The allocation of the value via invokation of the corresponding runtime function
        /// is lazy, and so are the necessary casts. When needed, instructions are emitted using the current builder.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="elementTypes">The Q# types of the tuple items</param>
        internal TupleValue CreateTuple(ImmutableArray<ResolvedType> elementTypes, bool registerWithScopeManager = true) =>
            new TupleValue(elementTypes, this.sharedState, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds a tuple with the items set to the given tuple elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="tupleElements">The tuple elements</param>
        internal TupleValue CreateTuple(ImmutableArray<TypedExpression> tupleElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new TupleValue(null, tupleElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds a tuple with the items set to the given tuple elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// Increases the reference count for the tuple elements.
        /// </summary>
        /// <param name="tupleElements">The tuple elements</param>
        /// <param name="registerWithScopeManager">Whether or not to register the built tuple with the scope manager</param>
        internal TupleValue CreateTuple(IReadOnlyList<IValue> tupleElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new TupleValue(null, tupleElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds a tuple with the items set to the given tuple elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="tupleElements">The tuple elements</param>
        internal TupleValue CreateCustomType(QsQualifiedName typeName, ImmutableArray<TypedExpression> tupleElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new TupleValue(typeName, tupleElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds a tuple representing a Q# value of user defined type with the items set to the given elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// Increases the reference count for the tuple elements.
        /// </summary>
        /// <param name="typeName">The name of the user defined type</param>
        /// <param name="tupleElements">The tuple elements</param>
        /// <param name="registerWithScopeManager">Whether or not to register the built tuple with the scope manager</param>
        internal TupleValue CreateCustomType(QsQualifiedName typeName, IReadOnlyList<IValue> tupleElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new TupleValue(typeName, tupleElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Creates a new array value of the given length. Expects a value of type i64 for the length of the array.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="elementType">Q# type of the array elements</param>
        /// <param name="length">Value of type i64 indicating the number of elements in the array</param>
        internal ArrayValue CreateArray(ResolvedType elementType, Value length, bool registerWithScopeManager = true) =>
            new ArrayValue(elementType, length, this.sharedState, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds an array that contains the given array elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="arrayElements">The elements in the array</param>
        internal ArrayValue CreateArray(ResolvedType elementType, ImmutableArray<TypedExpression> arrayElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new ArrayValue(elementType, arrayElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Builds an array that containsthe given array elements.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// Increases the reference count for the array elements.
        /// </summary>
        /// <param name="elementType">The Q# type of the array elements</param>
        /// <param name="arrayElements">The elements in the array</param>
        /// <param name="registerWithScopeManager">Whether or not to register the built tuple with the scope manager</param>
        internal ArrayValue CreateArray(ResolvedType elementType, IReadOnlyList<IValue> arrayElements, bool allocOnStack, bool registerWithScopeManager = true) =>
            new ArrayValue(elementType, arrayElements, this.sharedState, allocOnStack: allocOnStack, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Creates an array of the given size and populates each element with the value returned by <paramref name="getElement"/>,
        /// increasing its reference count accordingly. The function <paramref name="getElement"/> is invoked with the respective index.
        /// Registers the value with the scope manager, unless registerWithScopeManager is set to false.
        /// </summary>
        /// <param name="elementType">The Q# type of the array elements</param>
        /// <param name="length">Value of type i64 indicating the number of elements in the array</param>
        /// <param name="getElement">Given an index into the array, returns the value to populate that element with</param>
        /// <param name="registerWithScopeManager">Whether or not to register the built tuple with the scope manager</param>
        internal ArrayValue CreateArray(ResolvedType elementType, Value length, Func<Value, IValue> getElement, bool registerWithScopeManager = true) =>
            new ArrayValue(elementType, length, getElement, this.sharedState, registerWithScopeManager: registerWithScopeManager);

        /// <summary>
        /// Creates a callable value of the given type and registers it with the scope manager.
        /// The necessary functions to invoke the callable are defined by the callable table;
        /// i.e. the globally defined array of function pointers accessible via the given global variable.
        /// </summary>
        /// <param name="callableType">The Q# type of the callable value.</param>
        /// <param name="table">The global variable that contains the array of function pointers defining the callable.</param>
        /// <param name="captured">All captured values.</param>
        internal CallableValue CreateCallable(ResolvedType callableType, GlobalVariable table, ImmutableArray<TypedExpression>? captured = null) =>
            new CallableValue(callableType, table, this.sharedState, captured);
    }
}
