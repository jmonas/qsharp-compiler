// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Reflection;
using Microsoft.Quantum.QIR;
using Microsoft.Quantum.QsCompiler.DataTypes;
using Microsoft.Quantum.QsCompiler.SyntaxTree;
using Ubiquity.NET.Llvm;
using Ubiquity.NET.Llvm.DebugInfo;

namespace Microsoft.Quantum.QsCompiler.QIR
{
    /// <summary>
    /// This class holds shared utility routines for generating QIR debug information.
    /// It contains a reference to the GenerationContext that owns it because it needs
    /// access to the same shared state represented by the GenerationContext.
    /// </summary>
    internal sealed class DebugInfoManager
    {
        /// <summary>
        /// Dwarf version we are using for the debug info in the QIR generation
        /// </summary>
        private static readonly uint DwarfVersion = 4;

        /// <summary>
        /// Title of the CodeView module flag for debug info
        /// </summary>
        private static readonly string CodeviewName = "CodeView";

        /// <summary>
        /// CodeView version we are using for the debug info in the QIR generation
        /// </summary>
        private static readonly uint CodeviewVersion = 1;

        /// <summary>
        /// The source language information for Dwarf.
        /// For now, we are using the C interface. Ideally this would be a user defined language for Q#.
        /// </summary>
        private static readonly SourceLanguage QSharpLanguage = SourceLanguage.C99;

        /// <summary>
        /// Returns a string representing the producer information for the QIR
        /// </summary>
        private static string GetQirProducerIdent()
        {
            AssemblyName compilationInfo = CompilationLoader.GetQSharpCompilerAssemblyName();
            AssemblyName qirGenerationInfo = Assembly.GetExecutingAssembly().GetName();
            return compilationInfo.Name + " with " + qirGenerationInfo.Name + " V " + qirGenerationInfo.Version;
        }

        /// <summary>
        /// Whether or not to emit debug information during QIR generation
        /// </summary>
        public bool DebugFlag { get; } = false;

        /// <summary>
        /// Contains the location information for the syntax tree node we are currently parsing and its parents
        /// Currently this is only used for statement nodes, but will be used for other types of nodes in the future
        /// </summary>
        internal Stack<QsNullable<QsLocation>> LocationStack { get; }

        /// <summary>
        /// The GenerationContext that owns this DebugInfoManager
        /// </summary>
        private readonly GenerationContext sharedState;

        /// <summary>
        /// Contains the DIBuilders included in the module related to this DebugInfoManager.
        /// The key is the source file path of the DebugInfoBuilder's compile unit
        /// </summary>
        private readonly Dictionary<string, DebugInfoBuilder> dIBuilders;

        /// <summary>
        /// Access to the GenerationContext's Context
        /// </summary>
        private Context Context => this.sharedState.Context;

        /// <summary>
        /// Access to the GenerationContext's Module
        /// </summary>
        private BitcodeModule Module => this.sharedState.Module;

        internal DebugInfoManager(GenerationContext generationContext)
        {
            this.sharedState = generationContext;
            this.LocationStack = new Stack<QsNullable<QsLocation>>();
            this.dIBuilders = new Dictionary<string, DebugInfoBuilder>();
        }

        /// <summary>
        /// Gets the Dwarf version we are using for the debug info in the QIR generation
        /// </summary>
        private uint GetDwarfVersion() => DwarfVersion;

        /// <summary>
        /// Gets the CodeView version we are using for the debug info in the QIR generation
        /// </summary>
        private string GetCodeViewName() => CodeviewName;

        /// <summary>
        /// Gets the title for the CodeView module flag for debug info
        /// </summary>
        private uint GetCodeViewVersion() => CodeviewVersion;

        /// <summary>
        /// Creates a moduleID which lists all source files with debug info
        /// And makes the necessary calls to finalize the DIBuilders
        /// </summary>
        internal void FinalizeDebugInfo()
        {
            if (this.DebugFlag)
            {
                string moduleID = "";
                foreach (KeyValuePair<string, DebugInfoBuilder> entry in this.dIBuilders)
                {
                    entry.Value.Finish(); // must be called for every DIBuilder after all QIR generation

                    string sourcePath = entry.Key;
                    if (!string.IsNullOrEmpty(moduleID))
                    {
                        moduleID += ", ";
                    }

                    moduleID += Path.GetFileName(sourcePath);
                }

                // TODO: set module ID. Decide how to actually create the moduleID (above way could be very long)
            }
        }

        /// <summary>
        /// Gets the DebugInfoBuilder with a CompileUnit associated with this source file if it has already been created,
        /// Creates a DebugInfoBuilder with a CompileUnit associated with this source file otherwise.
        /// </summary>
        /// <param name="sourcePath">The source file's path for this compile unit</param>
        /// <returns>The compile unit related to this source file</returns>
        private DebugInfoBuilder GetOrCreateDIBuilder(string sourcePath)
        {
            if (string.IsNullOrWhiteSpace(sourcePath))
            {
                throw new ArgumentException("Expected valid sourcePath");
            }

            DebugInfoBuilder di;
            if (this.dIBuilders.TryGetValue(sourcePath, out di))
            {
                return di;
            }
            else
            {
                // Change the extension for to .c because of the language/extension issue
                string cSourcePath = Path.ChangeExtension(sourcePath, ".c");

                // TODO: If we need compilation flags (an optional argument to CreateCompileUnit) in the future we will need
                // to figure out how to get the compile options in the CompilationLoader.Configuration
                // and turn them into a string (although the compilation flags don't seem to be emitted to the IR anyways)
                di = this.Module.CreateDIBuilder();
                di.CreateCompileUnit(
                    QSharpLanguage, // Note that to debug the source file, you'll have to copy the content of the .qs file into a .c file with the same name
                    cSourcePath,
                    GetQirProducerIdent(),
                    null);
                this.dIBuilders.Add(sourcePath, di);
                return di;
            }
        }

        /// <summary>
        /// If DebugFlag is set to true, creates Adds top level debug info to the module,
        /// Note: because this is called from within the constructor of the GenerationContext,
        /// we cannot access this.Module or anything else that uses this.sharedState
        /// </summary>
        internal void AddTopLevelDebugInfo(BitcodeModule owningModule, ImmutableArray<QsQualifiedName> entryPoints)
        {
            if (this.DebugFlag)
            {
                // Add Module identity and Module Flags
                owningModule.AddProducerIdentMetadata(GetQirProducerIdent());

                // TODO: ModuleFlagBehavior.Warning is emitting a 1 (indicating error) instead of 2
                owningModule.AddModuleFlag(ModuleFlagBehavior.Warning, BitcodeModule.DwarfVersionValue, this.GetDwarfVersion());
                owningModule.AddModuleFlag(ModuleFlagBehavior.Warning, BitcodeModule.DebugVersionValue, BitcodeModule.DebugMetadataVersion);
                owningModule.AddModuleFlag(ModuleFlagBehavior.Warning, this.GetCodeViewName(), this.GetCodeViewVersion()); // TODO: We seem to need this flag and not Dwarf in order to debug on Windows. Need to look into why LLDB is using CodeView on Windows

                // TODO: could be useful to have target-specific module flags at some point
                // Examples: AddModuleFlag(ModuleFlagBehavior.Error, "PIC Level", 2); (ModuleFlagBehavior.Error, "wchar_size", 4); (ModuleFlagBehavior.Error, "min_enum_size", 4)

                // For now this is here to demonstrate a compilation unit being added, but eventually this will be called whenever a new file is encountered and not here.
                // Get the source file path from an entry point.
                string sourcePath = "";
                if (!entryPoints.IsEmpty)
                {
                    if (this.sharedState.TryGetGlobalCallable(entryPoints[0], out QsCallable? entry))
                    {
                        sourcePath = entry.Source.CodeFile;
                    }
                    else
                    {
                        throw new Exception("Entry point not found");
                    }
                }
                else
                {
                    throw new Exception("No entry point found in the source code");
                }

                this.GetOrCreateDIBuilder(sourcePath);
            }
        }
    }
}