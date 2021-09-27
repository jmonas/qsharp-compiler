; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx11.0.0"

%String = type opaque
%Array = type { i64, i64, i8*, i64, i64 }

define i64 @ConstArrayReduction__Main__Interop() local_unnamed_addr #0 {
entry:
  %0 = tail call fastcc i64 @ConstArrayReduction__Main__body()
  ret i64 %0
}

define internal fastcc i64 @ConstArrayReduction__Main__body() unnamed_addr personality i32 (...)* @__gxx_personality_v0 {
entry:
  %0 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %1 = bitcast i8* %0 to i64*
  store i64 8, i64* %1, align 8
  %2 = getelementptr inbounds i8, i8* %0, i64 8
  %3 = bitcast i8* %2 to i64*
  store i64 10, i64* %3, align 8
  %4 = getelementptr inbounds i8, i8* %0, i64 24
  %5 = bitcast i8* %4 to i64*
  store i64 0, i64* %5, align 8
  %6 = getelementptr inbounds i8, i8* %0, i64 32
  %7 = bitcast i8* %6 to i64*
  store i64 1, i64* %7, align 8
  %8 = load i64, i64* %1, align 8
  %9 = load i64, i64* %3, align 8
  %10 = mul nsw i64 %9, %8
  %11 = invoke noalias nonnull i8* @_Znam(i64 %10)
          to label %__quantum__rt__array_create_1d.exit unwind label %12

12:                                               ; preds = %entry
  %13 = landingpad { i8*, i32 }
          catch i8* null
  %14 = extractvalue { i8*, i32 } %13, 0
  tail call void @__clang_call_terminate(i8* %14)
  unreachable

__quantum__rt__array_create_1d.exit:              ; preds = %entry
  %15 = getelementptr inbounds i8, i8* %0, i64 16
  %16 = bitcast i8* %15 to i8**
  store i8* %11, i8** %16, align 8
  %17 = bitcast i8* %11 to i64*
  %18 = load i64, i64* %1, align 8
  %19 = getelementptr inbounds i8, i8* %11, i64 %18
  %20 = bitcast i8* %19 to i64*
  %21 = shl nsw i64 %18, 1
  %22 = getelementptr inbounds i8, i8* %11, i64 %21
  %23 = bitcast i8* %22 to i64*
  %24 = mul nsw i64 %18, 3
  %25 = getelementptr inbounds i8, i8* %11, i64 %24
  %26 = bitcast i8* %25 to i64*
  %27 = shl nsw i64 %18, 2
  %28 = getelementptr inbounds i8, i8* %11, i64 %27
  %29 = bitcast i8* %28 to i64*
  %30 = mul nsw i64 %18, 5
  %31 = getelementptr inbounds i8, i8* %11, i64 %30
  %32 = bitcast i8* %31 to i64*
  %33 = mul nsw i64 %18, 6
  %34 = getelementptr inbounds i8, i8* %11, i64 %33
  %35 = bitcast i8* %34 to i64*
  %36 = mul nsw i64 %18, 7
  %37 = getelementptr inbounds i8, i8* %11, i64 %36
  %38 = bitcast i8* %37 to i64*
  %39 = shl nsw i64 %18, 3
  %40 = getelementptr inbounds i8, i8* %11, i64 %39
  %41 = bitcast i8* %40 to i64*
  %42 = mul nsw i64 %18, 9
  %43 = getelementptr inbounds i8, i8* %11, i64 %42
  %44 = bitcast i8* %43 to i64*
  store i64 1, i64* %17, align 4
  store i64 2, i64* %20, align 4
  store i64 3, i64* %23, align 4
  store i64 4, i64* %26, align 4
  store i64 5, i64* %29, align 4
  store i64 6, i64* %32, align 4
  store i64 7, i64* %35, align 4
  store i64 8, i64* %38, align 4
  store i64 9, i64* %41, align 4
  store i64 10, i64* %44, align 4
  %45 = load i64, i64* %5, align 8
  %46 = add nsw i64 %45, 1
  store i64 %46, i64* %5, align 8
  %47 = load i64, i64* %7, align 8
  %48 = add nsw i64 %47, 1
  store i64 %48, i64* %7, align 8
  %49 = load i64, i64* %5, align 8
  %50 = add nsw i64 %49, -1
  store i64 %50, i64* %5, align 8
  %51 = icmp sgt i64 %49, 1
  br i1 %51, label %52, label %__quantum__rt__array_copy.exit

52:                                               ; preds = %__quantum__rt__array_create_1d.exit
  %53 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %54 = bitcast i8* %53 to i64*
  %55 = load i64, i64* %1, align 8
  store i64 %55, i64* %54, align 8
  %56 = getelementptr inbounds i8, i8* %53, i64 8
  %57 = bitcast i8* %56 to i64*
  %58 = load i64, i64* %3, align 8
  store i64 %58, i64* %57, align 8
  %59 = getelementptr inbounds i8, i8* %53, i64 24
  %60 = bitcast i8* %59 to i64*
  store i64 0, i64* %60, align 8
  %61 = getelementptr inbounds i8, i8* %53, i64 32
  %62 = bitcast i8* %61 to i64*
  store i64 1, i64* %62, align 8
  %63 = load i64, i64* %54, align 8
  %64 = load i64, i64* %57, align 8
  %65 = mul nsw i64 %64, %63
  %66 = invoke noalias nonnull i8* @_Znam(i64 %65)
          to label %_ZN5ArrayC1EPS_.exit.i unwind label %67

67:                                               ; preds = %52
  %68 = landingpad { i8*, i32 }
          catch i8* null
  %69 = extractvalue { i8*, i32 } %68, 0
  tail call void @__clang_call_terminate(i8* %69)
  unreachable

_ZN5ArrayC1EPS_.exit.i:                           ; preds = %52
  %70 = getelementptr inbounds i8, i8* %53, i64 16
  %71 = bitcast i8* %70 to i8**
  store i8* %66, i8** %71, align 8
  %72 = load i8*, i8** %16, align 8
  %73 = load i64, i64* %54, align 8
  %74 = load i64, i64* %57, align 8
  %75 = mul nsw i64 %74, %73
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %72, i8* nonnull align 1 %66, i64 %75, i1 false)
  br label %__quantum__rt__array_copy.exit

__quantum__rt__array_copy.exit:                   ; preds = %__quantum__rt__array_create_1d.exit, %_ZN5ArrayC1EPS_.exit.i
  %.pre-phi6 = phi i64* [ %5, %__quantum__rt__array_create_1d.exit ], [ %60, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi5 = phi i64* [ %7, %__quantum__rt__array_create_1d.exit ], [ %62, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi4 = phi i64* [ %1, %__quantum__rt__array_create_1d.exit ], [ %54, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi = phi i8** [ %16, %__quantum__rt__array_create_1d.exit ], [ %71, %_ZN5ArrayC1EPS_.exit.i ]
  %.0.i.in = phi i8* [ %0, %__quantum__rt__array_create_1d.exit ], [ %53, %_ZN5ArrayC1EPS_.exit.i ]
  %76 = load i8*, i8** %.pre-phi, align 8
  %77 = load i64, i64* %.pre-phi4, align 8
  %78 = mul nsw i64 %77, 7
  %79 = getelementptr inbounds i8, i8* %76, i64 %78
  %80 = bitcast i8* %79 to i64*
  store i64 1337, i64* %80, align 4
  %81 = load i64, i64* %.pre-phi5, align 8
  %82 = add nsw i64 %81, 1
  store i64 %82, i64* %.pre-phi5, align 8
  %83 = load i64, i64* %.pre-phi6, align 8
  %84 = icmp sgt i64 %83, 0
  br i1 %84, label %85, label %__quantum__rt__array_copy.exit3

85:                                               ; preds = %__quantum__rt__array_copy.exit
  %86 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %87 = bitcast i8* %86 to i64*
  %88 = load i64, i64* %.pre-phi4, align 8
  store i64 %88, i64* %87, align 8
  %89 = getelementptr inbounds i8, i8* %86, i64 8
  %90 = bitcast i8* %89 to i64*
  %91 = getelementptr inbounds i8, i8* %.0.i.in, i64 8
  %92 = bitcast i8* %91 to i64*
  %93 = load i64, i64* %92, align 8
  store i64 %93, i64* %90, align 8
  %94 = getelementptr inbounds i8, i8* %86, i64 24
  %95 = bitcast i8* %94 to i64*
  store i64 0, i64* %95, align 8
  %96 = getelementptr inbounds i8, i8* %86, i64 32
  %97 = bitcast i8* %96 to i64*
  store i64 1, i64* %97, align 8
  %98 = load i64, i64* %87, align 8
  %99 = load i64, i64* %90, align 8
  %100 = mul nsw i64 %99, %98
  %101 = invoke noalias nonnull i8* @_Znam(i64 %100)
          to label %_ZN5ArrayC1EPS_.exit.i1 unwind label %102

102:                                              ; preds = %85
  %103 = landingpad { i8*, i32 }
          catch i8* null
  %104 = extractvalue { i8*, i32 } %103, 0
  tail call void @__clang_call_terminate(i8* %104)
  unreachable

_ZN5ArrayC1EPS_.exit.i1:                          ; preds = %85
  %105 = getelementptr inbounds i8, i8* %86, i64 16
  %106 = bitcast i8* %105 to i8**
  store i8* %101, i8** %106, align 8
  %107 = load i8*, i8** %.pre-phi, align 8
  %108 = load i64, i64* %87, align 8
  %109 = load i64, i64* %90, align 8
  %110 = mul nsw i64 %109, %108
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %107, i8* nonnull align 1 %101, i64 %110, i1 false)
  br label %__quantum__rt__array_copy.exit3

__quantum__rt__array_copy.exit3:                  ; preds = %__quantum__rt__array_copy.exit, %_ZN5ArrayC1EPS_.exit.i1
  %.pre-phi10 = phi i64* [ %.pre-phi6, %__quantum__rt__array_copy.exit ], [ %95, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi9 = phi i64* [ %.pre-phi5, %__quantum__rt__array_copy.exit ], [ %97, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi8 = phi i64* [ %.pre-phi4, %__quantum__rt__array_copy.exit ], [ %87, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi7 = phi i8** [ %.pre-phi, %__quantum__rt__array_copy.exit ], [ %106, %_ZN5ArrayC1EPS_.exit.i1 ]
  %111 = load i8*, i8** %.pre-phi, align 8
  %112 = load i64, i64* %.pre-phi4, align 8
  %113 = mul nsw i64 %112, 7
  %114 = getelementptr inbounds i8, i8* %111, i64 %113
  %115 = bitcast i8* %114 to i64*
  %116 = load i64, i64* %115, align 4
  %117 = load i8*, i8** %.pre-phi7, align 8
  %118 = load i64, i64* %.pre-phi8, align 8
  %119 = mul nsw i64 %118, 3
  %120 = getelementptr inbounds i8, i8* %117, i64 %119
  %121 = bitcast i8* %120 to i64*
  store i64 %116, i64* %121, align 4
  %122 = load i64, i64* %.pre-phi9, align 8
  %123 = add nsw i64 %122, 1
  store i64 %123, i64* %.pre-phi9, align 8
  %124 = load i64, i64* %.pre-phi10, align 8
  %125 = add nsw i64 %124, 1
  store i64 %125, i64* %.pre-phi10, align 8
  %126 = load i8*, i8** %.pre-phi7, align 8
  %127 = load i64, i64* %.pre-phi8, align 8
  %128 = mul nsw i64 %127, 3
  %129 = getelementptr inbounds i8, i8* %126, i64 %128
  %130 = bitcast i8* %129 to i64*
  %131 = load i64, i64* %130, align 4
  store i64 %124, i64* %.pre-phi10, align 8
  %132 = load i64, i64* %7, align 8
  %133 = add nsw i64 %132, -2
  store i64 %133, i64* %7, align 8
  %134 = load i64, i64* %.pre-phi5, align 8
  %135 = add nsw i64 %134, -2
  store i64 %135, i64* %.pre-phi5, align 8
  %136 = load i64, i64* %.pre-phi9, align 8
  %137 = add nsw i64 %136, -2
  store i64 %137, i64* %.pre-phi9, align 8
  ret i64 %131
}

define void @ConstArrayReduction__Main() local_unnamed_addr #1 {
entry:
  %0 = call i64 @ConstArrayReduction__Main__body.11()
  %1 = tail call %String* @__quantum__rt__int_to_string(i64 %0)
  ret void
}

declare %String* @__quantum__rt__int_to_string(i64) local_unnamed_addr

declare void @__quantum__rt__message(%String*) local_unnamed_addr

declare void @__quantum__rt__string_update_reference_count(%String*, i32) local_unnamed_addr

define noalias nonnull %Array* @__quantum__rt__array_create_1d(i32 %0, i64 %1) local_unnamed_addr personality i32 (...)* @__gxx_personality_v0 {
  %3 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %4 = sext i32 %0 to i64
  %5 = bitcast i8* %3 to i64*
  store i64 %4, i64* %5, align 8
  %6 = getelementptr inbounds i8, i8* %3, i64 8
  %7 = bitcast i8* %6 to i64*
  store i64 %1, i64* %7, align 8
  %8 = getelementptr inbounds i8, i8* %3, i64 24
  %9 = bitcast i8* %8 to i64*
  store i64 0, i64* %9, align 8
  %10 = getelementptr inbounds i8, i8* %3, i64 32
  %11 = bitcast i8* %10 to i64*
  store i64 1, i64* %11, align 8
  %12 = load i64, i64* %5, align 8
  %13 = load i64, i64* %7, align 8
  %14 = mul nsw i64 %13, %12
  %15 = invoke noalias nonnull i8* @_Znam(i64 %14)
          to label %_ZN5ArrayC1Exx.exit unwind label %16

16:                                               ; preds = %2
  %17 = landingpad { i8*, i32 }
          catch i8* null
  %18 = extractvalue { i8*, i32 } %17, 0
  tail call void @__clang_call_terminate(i8* %18)
  unreachable

_ZN5ArrayC1Exx.exit:                              ; preds = %2
  %19 = bitcast i8* %3 to %Array*
  %20 = getelementptr inbounds i8, i8* %3, i64 16
  %21 = bitcast i8* %20 to i8**
  store i8* %15, i8** %21, align 8
  ret %Array* %19
}

; Function Attrs: nofree
declare noalias nonnull i8* @_Znwm(i64) local_unnamed_addr #2

declare i32 @__gxx_personality_v0(...)

; Function Attrs: nofree
declare noalias nonnull i8* @_Znam(i64) local_unnamed_addr #2

define linkonce_odr hidden void @__clang_call_terminate(i8* %0) local_unnamed_addr {
  %2 = tail call i8* @__cxa_begin_catch(i8* %0)
  tail call void @_ZSt9terminatev()
  unreachable
}

declare i8* @__cxa_begin_catch(i8*) local_unnamed_addr

declare void @_ZSt9terminatev() local_unnamed_addr

; Function Attrs: norecurse nounwind readonly
define i8* @__quantum__rt__array_get_element_ptr_1d(%Array* nocapture readonly %0, i64 %1) local_unnamed_addr #3 {
  %3 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 2
  %4 = load i8*, i8** %3, align 8
  %5 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 0
  %6 = load i64, i64* %5, align 8
  %7 = mul nsw i64 %6, %1
  %8 = getelementptr inbounds i8, i8* %4, i64 %7
  ret i8* %8
}

define void @__quantum__rt__qubit_release_array(%Array* %0) local_unnamed_addr {
  %2 = icmp eq %Array* %0, null
  br i1 %2, label %9, label %3

3:                                                ; preds = %1
  %4 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 2
  %5 = load i8*, i8** %4, align 8
  %6 = icmp eq i8* %5, null
  br i1 %6, label %_ZN5ArrayD1Ev.exit, label %7

7:                                                ; preds = %3
  tail call void @_ZdaPv(i8* nonnull %5)
  br label %_ZN5ArrayD1Ev.exit

_ZN5ArrayD1Ev.exit:                               ; preds = %3, %7
  %8 = bitcast %Array* %0 to i8*
  tail call void @_ZdlPv(i8* %8)
  br label %9

9:                                                ; preds = %_ZN5ArrayD1Ev.exit, %1
  ret void
}

declare void @_ZdlPv(i8*) local_unnamed_addr

declare void @_ZdaPv(i8*) local_unnamed_addr

; Function Attrs: nofree norecurse nounwind
define void @__quantum__rt__array_update_alias_count(%Array* nocapture %0, i32 %1) local_unnamed_addr #4 {
  %3 = sext i32 %1 to i64
  %4 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 3
  %5 = load i64, i64* %4, align 8
  %6 = add nsw i64 %5, %3
  store i64 %6, i64* %4, align 8
  ret void
}

; Function Attrs: nofree norecurse nounwind
define void @__quantum__rt__array_update_reference_count(%Array* nocapture %0, i32 %1) local_unnamed_addr #4 {
  %3 = sext i32 %1 to i64
  %4 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 4
  %5 = load i64, i64* %4, align 8
  %6 = add nsw i64 %5, %3
  store i64 %6, i64* %4, align 8
  ret void
}

define %Array* @__quantum__rt__array_copy(%Array* readonly %0, i1 zeroext %1) local_unnamed_addr personality i32 (...)* @__gxx_personality_v0 {
  %3 = icmp eq %Array* %0, null
  br i1 %3, label %37, label %4

4:                                                ; preds = %2
  br i1 %1, label %9, label %5

5:                                                ; preds = %4
  %6 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 3
  %7 = load i64, i64* %6, align 8
  %8 = icmp sgt i64 %7, 0
  br i1 %8, label %9, label %37

9:                                                ; preds = %5, %4
  %10 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %11 = bitcast i8* %10 to i64*
  %12 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 0
  %13 = load i64, i64* %12, align 8
  store i64 %13, i64* %11, align 8
  %14 = getelementptr inbounds i8, i8* %10, i64 8
  %15 = bitcast i8* %14 to i64*
  %16 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 1
  %17 = load i64, i64* %16, align 8
  store i64 %17, i64* %15, align 8
  %18 = getelementptr inbounds i8, i8* %10, i64 24
  %19 = bitcast i8* %18 to i64*
  store i64 0, i64* %19, align 8
  %20 = getelementptr inbounds i8, i8* %10, i64 32
  %21 = bitcast i8* %20 to i64*
  store i64 1, i64* %21, align 8
  %22 = load i64, i64* %11, align 8
  %23 = load i64, i64* %15, align 8
  %24 = mul nsw i64 %23, %22
  %25 = invoke noalias nonnull i8* @_Znam(i64 %24)
          to label %_ZN5ArrayC1EPS_.exit unwind label %26

26:                                               ; preds = %9
  %27 = landingpad { i8*, i32 }
          catch i8* null
  %28 = extractvalue { i8*, i32 } %27, 0
  tail call void @__clang_call_terminate(i8* %28)
  unreachable

_ZN5ArrayC1EPS_.exit:                             ; preds = %9
  %29 = bitcast i8* %10 to %Array*
  %30 = getelementptr inbounds i8, i8* %10, i64 16
  %31 = bitcast i8* %30 to i8**
  store i8* %25, i8** %31, align 8
  %32 = getelementptr inbounds %Array, %Array* %0, i64 0, i32 2
  %33 = load i8*, i8** %32, align 8
  %34 = load i64, i64* %11, align 8
  %35 = load i64, i64* %15, align 8
  %36 = mul nsw i64 %35, %34
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %33, i8* nonnull align 1 %25, i64 %36, i1 false)
  br label %37

37:                                               ; preds = %5, %2, %_ZN5ArrayC1EPS_.exit
  %.0 = phi %Array* [ %29, %_ZN5ArrayC1EPS_.exit ], [ null, %2 ], [ %0, %5 ]
  ret %Array* %.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

define internal fastcc i64 @ConstArrayReduction__Main__body.11() unnamed_addr personality i32 (...)* @__gxx_personality_v0 {
entry:
  %0 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %1 = bitcast i8* %0 to i64*
  store i64 8, i64* %1, align 8
  %2 = getelementptr inbounds i8, i8* %0, i64 8
  %3 = bitcast i8* %2 to i64*
  store i64 10, i64* %3, align 8
  %4 = getelementptr inbounds i8, i8* %0, i64 24
  %5 = bitcast i8* %4 to i64*
  store i64 0, i64* %5, align 8
  %6 = getelementptr inbounds i8, i8* %0, i64 32
  %7 = bitcast i8* %6 to i64*
  store i64 1, i64* %7, align 8
  %8 = load i64, i64* %1, align 8
  %9 = load i64, i64* %3, align 8
  %10 = mul nsw i64 %9, %8
  %11 = invoke noalias nonnull i8* @_Znam(i64 %10)
          to label %__quantum__rt__array_create_1d.exit unwind label %12

12:                                               ; preds = %entry
  %13 = landingpad { i8*, i32 }
          catch i8* null
  %14 = extractvalue { i8*, i32 } %13, 0
  tail call void @__clang_call_terminate(i8* %14)
  unreachable

__quantum__rt__array_create_1d.exit:              ; preds = %entry
  %15 = getelementptr inbounds i8, i8* %0, i64 16
  %16 = bitcast i8* %15 to i8**
  store i8* %11, i8** %16, align 8
  %17 = bitcast i8* %11 to i64*
  %18 = load i64, i64* %1, align 8
  %19 = getelementptr inbounds i8, i8* %11, i64 %18
  %20 = bitcast i8* %19 to i64*
  %21 = shl nsw i64 %18, 1
  %22 = getelementptr inbounds i8, i8* %11, i64 %21
  %23 = bitcast i8* %22 to i64*
  %24 = mul nsw i64 %18, 3
  %25 = getelementptr inbounds i8, i8* %11, i64 %24
  %26 = bitcast i8* %25 to i64*
  %27 = shl nsw i64 %18, 2
  %28 = getelementptr inbounds i8, i8* %11, i64 %27
  %29 = bitcast i8* %28 to i64*
  %30 = mul nsw i64 %18, 5
  %31 = getelementptr inbounds i8, i8* %11, i64 %30
  %32 = bitcast i8* %31 to i64*
  %33 = mul nsw i64 %18, 6
  %34 = getelementptr inbounds i8, i8* %11, i64 %33
  %35 = bitcast i8* %34 to i64*
  %36 = mul nsw i64 %18, 7
  %37 = getelementptr inbounds i8, i8* %11, i64 %36
  %38 = bitcast i8* %37 to i64*
  %39 = shl nsw i64 %18, 3
  %40 = getelementptr inbounds i8, i8* %11, i64 %39
  %41 = bitcast i8* %40 to i64*
  %42 = mul nsw i64 %18, 9
  %43 = getelementptr inbounds i8, i8* %11, i64 %42
  %44 = bitcast i8* %43 to i64*
  store i64 1, i64* %17, align 4
  store i64 2, i64* %20, align 4
  store i64 3, i64* %23, align 4
  store i64 4, i64* %26, align 4
  store i64 5, i64* %29, align 4
  store i64 6, i64* %32, align 4
  store i64 7, i64* %35, align 4
  store i64 8, i64* %38, align 4
  store i64 9, i64* %41, align 4
  store i64 10, i64* %44, align 4
  %45 = load i64, i64* %5, align 8
  %46 = add nsw i64 %45, 1
  store i64 %46, i64* %5, align 8
  %47 = load i64, i64* %7, align 8
  %48 = add nsw i64 %47, 1
  store i64 %48, i64* %7, align 8
  %49 = load i64, i64* %5, align 8
  %50 = add nsw i64 %49, -1
  store i64 %50, i64* %5, align 8
  %51 = icmp sgt i64 %49, 1
  br i1 %51, label %52, label %__quantum__rt__array_copy.exit

52:                                               ; preds = %__quantum__rt__array_create_1d.exit
  %53 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %54 = bitcast i8* %53 to i64*
  %55 = load i64, i64* %1, align 8
  store i64 %55, i64* %54, align 8
  %56 = getelementptr inbounds i8, i8* %53, i64 8
  %57 = bitcast i8* %56 to i64*
  %58 = load i64, i64* %3, align 8
  store i64 %58, i64* %57, align 8
  %59 = getelementptr inbounds i8, i8* %53, i64 24
  %60 = bitcast i8* %59 to i64*
  store i64 0, i64* %60, align 8
  %61 = getelementptr inbounds i8, i8* %53, i64 32
  %62 = bitcast i8* %61 to i64*
  store i64 1, i64* %62, align 8
  %63 = load i64, i64* %54, align 8
  %64 = load i64, i64* %57, align 8
  %65 = mul nsw i64 %64, %63
  %66 = invoke noalias nonnull i8* @_Znam(i64 %65)
          to label %_ZN5ArrayC1EPS_.exit.i unwind label %67

67:                                               ; preds = %52
  %68 = landingpad { i8*, i32 }
          catch i8* null
  %69 = extractvalue { i8*, i32 } %68, 0
  tail call void @__clang_call_terminate(i8* %69)
  unreachable

_ZN5ArrayC1EPS_.exit.i:                           ; preds = %52
  %70 = getelementptr inbounds i8, i8* %53, i64 16
  %71 = bitcast i8* %70 to i8**
  store i8* %66, i8** %71, align 8
  %72 = load i8*, i8** %16, align 8
  %73 = load i64, i64* %54, align 8
  %74 = load i64, i64* %57, align 8
  %75 = mul nsw i64 %74, %73
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %72, i8* nonnull align 1 %66, i64 %75, i1 false)
  br label %__quantum__rt__array_copy.exit

__quantum__rt__array_copy.exit:                   ; preds = %_ZN5ArrayC1EPS_.exit.i, %__quantum__rt__array_create_1d.exit
  %.pre-phi6 = phi i64* [ %5, %__quantum__rt__array_create_1d.exit ], [ %60, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi5 = phi i64* [ %7, %__quantum__rt__array_create_1d.exit ], [ %62, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi4 = phi i64* [ %1, %__quantum__rt__array_create_1d.exit ], [ %54, %_ZN5ArrayC1EPS_.exit.i ]
  %.pre-phi = phi i8** [ %16, %__quantum__rt__array_create_1d.exit ], [ %71, %_ZN5ArrayC1EPS_.exit.i ]
  %.0.i.in = phi i8* [ %0, %__quantum__rt__array_create_1d.exit ], [ %53, %_ZN5ArrayC1EPS_.exit.i ]
  %76 = load i8*, i8** %.pre-phi, align 8
  %77 = load i64, i64* %.pre-phi4, align 8
  %78 = mul nsw i64 %77, 7
  %79 = getelementptr inbounds i8, i8* %76, i64 %78
  %80 = bitcast i8* %79 to i64*
  store i64 1337, i64* %80, align 4
  %81 = load i64, i64* %.pre-phi5, align 8
  %82 = add nsw i64 %81, 1
  store i64 %82, i64* %.pre-phi5, align 8
  %83 = load i64, i64* %.pre-phi6, align 8
  %84 = icmp sgt i64 %83, 0
  br i1 %84, label %85, label %__quantum__rt__array_copy.exit3

85:                                               ; preds = %__quantum__rt__array_copy.exit
  %86 = tail call noalias nonnull dereferenceable(40) i8* @_Znwm(i64 40)
  %87 = bitcast i8* %86 to i64*
  %88 = load i64, i64* %.pre-phi4, align 8
  store i64 %88, i64* %87, align 8
  %89 = getelementptr inbounds i8, i8* %86, i64 8
  %90 = bitcast i8* %89 to i64*
  %91 = getelementptr inbounds i8, i8* %.0.i.in, i64 8
  %92 = bitcast i8* %91 to i64*
  %93 = load i64, i64* %92, align 8
  store i64 %93, i64* %90, align 8
  %94 = getelementptr inbounds i8, i8* %86, i64 24
  %95 = bitcast i8* %94 to i64*
  store i64 0, i64* %95, align 8
  %96 = getelementptr inbounds i8, i8* %86, i64 32
  %97 = bitcast i8* %96 to i64*
  store i64 1, i64* %97, align 8
  %98 = load i64, i64* %87, align 8
  %99 = load i64, i64* %90, align 8
  %100 = mul nsw i64 %99, %98
  %101 = invoke noalias nonnull i8* @_Znam(i64 %100)
          to label %_ZN5ArrayC1EPS_.exit.i1 unwind label %102

102:                                              ; preds = %85
  %103 = landingpad { i8*, i32 }
          catch i8* null
  %104 = extractvalue { i8*, i32 } %103, 0
  tail call void @__clang_call_terminate(i8* %104)
  unreachable

_ZN5ArrayC1EPS_.exit.i1:                          ; preds = %85
  %105 = getelementptr inbounds i8, i8* %86, i64 16
  %106 = bitcast i8* %105 to i8**
  store i8* %101, i8** %106, align 8
  %107 = load i8*, i8** %.pre-phi, align 8
  %108 = load i64, i64* %87, align 8
  %109 = load i64, i64* %90, align 8
  %110 = mul nsw i64 %109, %108
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %107, i8* nonnull align 1 %101, i64 %110, i1 false)
  br label %__quantum__rt__array_copy.exit3

__quantum__rt__array_copy.exit3:                  ; preds = %_ZN5ArrayC1EPS_.exit.i1, %__quantum__rt__array_copy.exit
  %.pre-phi10 = phi i64* [ %.pre-phi6, %__quantum__rt__array_copy.exit ], [ %95, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi9 = phi i64* [ %.pre-phi5, %__quantum__rt__array_copy.exit ], [ %97, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi8 = phi i64* [ %.pre-phi4, %__quantum__rt__array_copy.exit ], [ %87, %_ZN5ArrayC1EPS_.exit.i1 ]
  %.pre-phi7 = phi i8** [ %.pre-phi, %__quantum__rt__array_copy.exit ], [ %106, %_ZN5ArrayC1EPS_.exit.i1 ]
  %111 = load i8*, i8** %.pre-phi, align 8
  %112 = load i64, i64* %.pre-phi4, align 8
  %113 = mul nsw i64 %112, 7
  %114 = getelementptr inbounds i8, i8* %111, i64 %113
  %115 = bitcast i8* %114 to i64*
  %116 = load i64, i64* %115, align 4
  %117 = load i8*, i8** %.pre-phi7, align 8
  %118 = load i64, i64* %.pre-phi8, align 8
  %119 = mul nsw i64 %118, 3
  %120 = getelementptr inbounds i8, i8* %117, i64 %119
  %121 = bitcast i8* %120 to i64*
  store i64 %116, i64* %121, align 4
  %122 = load i64, i64* %.pre-phi9, align 8
  %123 = add nsw i64 %122, 1
  store i64 %123, i64* %.pre-phi9, align 8
  %124 = load i64, i64* %.pre-phi10, align 8
  %125 = add nsw i64 %124, 1
  store i64 %125, i64* %.pre-phi10, align 8
  %126 = load i8*, i8** %.pre-phi7, align 8
  %127 = load i64, i64* %.pre-phi8, align 8
  %128 = mul nsw i64 %127, 3
  %129 = getelementptr inbounds i8, i8* %126, i64 %128
  %130 = bitcast i8* %129 to i64*
  %131 = load i64, i64* %130, align 4
  store i64 %124, i64* %.pre-phi10, align 8
  %132 = load i64, i64* %7, align 8
  %133 = add nsw i64 %132, -2
  store i64 %133, i64* %7, align 8
  %134 = load i64, i64* %.pre-phi5, align 8
  %135 = add nsw i64 %134, -2
  store i64 %135, i64* %.pre-phi5, align 8
  %136 = load i64, i64* %.pre-phi9, align 8
  %137 = add nsw i64 %136, -2
  store i64 %137, i64* %.pre-phi9, align 8
  ret i64 %131
}

attributes #0 = { "InteropFriendly" }
attributes #1 = { "EntryPoint" }
attributes #2 = { nofree }
attributes #3 = { norecurse nounwind readonly }
attributes #4 = { nofree norecurse nounwind }
attributes #5 = { argmemonly nounwind willreturn }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2}

!0 = !{!"Homebrew clang version 11.1.0"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}

