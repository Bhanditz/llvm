; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mergeicmps -mtriple=x86_64-unknown-unknown -S | FileCheck %s

; This is a more involved test: clang generates this weird pattern for
; tuple<uint8_t, uint8_t, uint8_t, uint8_t>. Right now we skip the entry block
; (which defines the base pointer for other blocks) and the last one (which
; does not have the expected structure). Only middle blocks (bytes [1,2]) are
; merged.

%"class.std::tuple" = type { %"struct.std::_Tuple_impl" }
%"struct.std::_Tuple_impl" = type { %"struct.std::_Tuple_impl.0", %"struct.std::_Head_base.6" }
%"struct.std::_Tuple_impl.0" = type { %"struct.std::_Tuple_impl.1", %"struct.std::_Head_base.5" }
%"struct.std::_Tuple_impl.1" = type { %"struct.std::_Tuple_impl.2", %"struct.std::_Head_base.4" }
%"struct.std::_Tuple_impl.2" = type { %"struct.std::_Head_base" }
%"struct.std::_Head_base" = type { i8 }
%"struct.std::_Head_base.4" = type { i8 }
%"struct.std::_Head_base.5" = type { i8 }
%"struct.std::_Head_base.6" = type { i8 }

define zeroext i1 @opeq(
; CHECK-LABEL: @opeq(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds %"class.std::tuple", %"class.std::tuple"* [[A:%.*]], i64 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
; CHECK-NEXT:    [[ADD_PTR_I_I_I_I_I:%.*]] = getelementptr inbounds i8, i8* [[TMP0]], i64 3
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[ADD_PTR_I_I_I_I_I]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds %"class.std::tuple", %"class.std::tuple"* [[B:%.*]], i64 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
; CHECK-NEXT:    [[ADD_PTR_I_I_I6_I_I:%.*]] = getelementptr inbounds i8, i8* [[TMP2]], i64 3
; CHECK-NEXT:    [[TMP3:%.*]] = load i8, i8* [[ADD_PTR_I_I_I6_I_I]], align 1
; CHECK-NEXT:    [[CMP_I_I:%.*]] = icmp eq i8 [[TMP1]], [[TMP3]]
; CHECK-NEXT:    br i1 [[CMP_I_I]], label [[LAND_RHS_I_I_I:%.*]], label [[OPEQ_EXIT:%.*]]
; CHECK:       land.rhs.i.i.i:
; CHECK-NEXT:    [[ADD_PTR_I_I_I_I_I_I_I:%.*]] = getelementptr inbounds i8, i8* [[TMP0]], i64 1
; CHECK-NEXT:    [[ADD_PTR_I_I_I6_I_I_I_I:%.*]] = getelementptr inbounds i8, i8* [[TMP2]], i64 1
; CHECK-NEXT:    [[MEMCMP:%.*]] = call i32 @memcmp(i8* [[ADD_PTR_I_I_I6_I_I_I_I]], i8* [[ADD_PTR_I_I_I_I_I_I_I]], i64 2)
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[MEMCMP]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[LAND_RHS_I_I_I_I:%.*]], label [[OPEQ_EXIT]]
; CHECK:       land.rhs.i.i.i.i:
; CHECK-NEXT:    [[TMP5:%.*]] = load i8, i8* [[TMP0]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = load i8, i8* [[TMP2]], align 1
; CHECK-NEXT:    [[CMP_I_I_I_I_I:%.*]] = icmp eq i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br label [[OPEQ_EXIT]]
; CHECK:       opeq.exit:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i1 [ false, [[ENTRY:%.*]] ], [ false, [[LAND_RHS_I_I_I]] ], [ [[CMP_I_I_I_I_I]], [[LAND_RHS_I_I_I_I]] ]
; CHECK-NEXT:    ret i1 [[TMP7]]
;
  %"class.std::tuple"* nocapture readonly dereferenceable(4) %a,
  %"class.std::tuple"* nocapture readonly dereferenceable(4) %b) local_unnamed_addr #1 {
entry:
  %0 = getelementptr inbounds %"class.std::tuple", %"class.std::tuple"* %a, i64 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %add.ptr.i.i.i.i.i = getelementptr inbounds i8, i8* %0, i64 3
  %1 = load i8, i8* %add.ptr.i.i.i.i.i, align 1
  %2 = getelementptr inbounds %"class.std::tuple", %"class.std::tuple"* %b, i64 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %add.ptr.i.i.i6.i.i = getelementptr inbounds i8, i8* %2, i64 3
  %3 = load i8, i8* %add.ptr.i.i.i6.i.i, align 1
  %cmp.i.i = icmp eq i8 %1, %3
  br i1 %cmp.i.i, label %land.rhs.i.i, label %opeq.exit

land.rhs.i.i:
  %add.ptr.i.i.i.i.i.i = getelementptr inbounds i8, i8* %0, i64 2
  %4 = load i8, i8* %add.ptr.i.i.i.i.i.i, align 1
  %add.ptr.i.i.i6.i.i.i = getelementptr inbounds i8, i8* %2, i64 2
  %5 = load i8, i8* %add.ptr.i.i.i6.i.i.i, align 1
  %cmp.i.i.i = icmp eq i8 %4, %5
  br i1 %cmp.i.i.i, label %land.rhs.i.i.i, label %opeq.exit

land.rhs.i.i.i:
  %add.ptr.i.i.i.i.i.i.i = getelementptr inbounds i8, i8* %0, i64 1
  %6 = load i8, i8* %add.ptr.i.i.i.i.i.i.i, align 1
  %add.ptr.i.i.i6.i.i.i.i = getelementptr inbounds i8, i8* %2, i64 1
  %7 = load i8, i8* %add.ptr.i.i.i6.i.i.i.i, align 1
  %cmp.i.i.i.i = icmp eq i8 %6, %7
  br i1 %cmp.i.i.i.i, label %land.rhs.i.i.i.i, label %opeq.exit

land.rhs.i.i.i.i:
  %8 = load i8, i8* %0, align 1
  %9 = load i8, i8* %2, align 1
  %cmp.i.i.i.i.i = icmp eq i8 %8, %9
  br label %opeq.exit

opeq.exit:
  %10 = phi i1 [ false, %entry ], [ false, %land.rhs.i.i ], [ false, %land.rhs.i.i.i ], [ %cmp.i.i.i.i.i, %land.rhs.i.i.i.i ]
  ret i1 %10
; The entry block is kept as is, but the next block is now the merged comparison
; block for bytes [1,2] or the block for the head.
; The two 1 byte loads and compares at offset 1 are replaced with a single
; 2-byte memcmp.
; In the end we have three blocks.
; CHECK-SAME %entry
; CHECK-SAME %land.rhs.i.i.i.i
; CHECK-SAME %land.rhs.i.i.i
}
