define i64 @Microsoft__Quantum__Testing__QIR__TestDeconstruct__body(i64 %0, { i64, i64 }* %1) {
entry:
  %2 = call %Tuple* @__quantum__rt__tuple_create(i64 ptrtoint ({ i64, { i64, i64 }* }* getelementptr ({ i64, { i64, i64 }* }, { i64, { i64, i64 }* }* null, i32 1) to i64))
  %a = bitcast %Tuple* %2 to { i64, { i64, i64 }* }*
  %3 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 0
  %4 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 1
  store i64 %0, i64* %3
  store { i64, i64 }* %1, { i64, i64 }** %4
  %5 = bitcast { i64, i64 }* %1 to %Tuple*
  call void @__quantum__rt__tuple_reference(%Tuple* %5)
  %6 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 1
  %7 = load { i64, i64 }*, { i64, i64 }** %6
  %8 = bitcast { i64, i64 }* %7 to %Tuple*
  call void @__quantum__rt__tuple_add_access(%Tuple* %8)
  call void @__quantum__rt__tuple_add_access(%Tuple* %2)
  %9 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 0
  %x = load i64, i64* %9
  %10 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 1
  %y = load { i64, i64 }*, { i64, i64 }** %10
  %11 = bitcast { i64, i64 }* %y to %Tuple*
  call void @__quantum__rt__tuple_add_access(%Tuple* %11)
  %b = alloca i64
  store i64 3, i64* %b
  %c = alloca i64
  store i64 5, i64* %c
  %12 = getelementptr { i64, i64 }, { i64, i64 }* %y, i64 0, i32 0
  %13 = getelementptr { i64, i64 }, { i64, i64 }* %y, i64 0, i32 1
  %14 = load i64, i64* %12
  %15 = load i64, i64* %13
  store i64 %14, i64* %b
  store i64 %15, i64* %c
  %16 = mul i64 %14, %15
  %17 = add i64 %x, %16
  %18 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 1
  %19 = load { i64, i64 }*, { i64, i64 }** %18
  %20 = bitcast { i64, i64 }* %19 to %Tuple*
  call void @__quantum__rt__tuple_remove_access(%Tuple* %20)
  call void @__quantum__rt__tuple_remove_access(%Tuple* %2)
  call void @__quantum__rt__tuple_remove_access(%Tuple* %11)
  %21 = getelementptr { i64, { i64, i64 }* }, { i64, { i64, i64 }* }* %a, i64 0, i32 1
  %22 = load { i64, i64 }*, { i64, i64 }** %21
  %23 = bitcast { i64, i64 }* %22 to %Tuple*
  call void @__quantum__rt__tuple_unreference(%Tuple* %23)
  call void @__quantum__rt__tuple_unreference(%Tuple* %2)
  ret i64 %17
}