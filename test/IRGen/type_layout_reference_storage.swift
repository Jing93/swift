// RUN: %target-swift-frontend -emit-ir %s | FileCheck %s --check-prefix=CHECK-%target-ptrsize --check-prefix=CHECK

class C {}
protocol P: class {}
protocol Q: class {}

// CHECK: @_TMPdV29type_layout_reference_storage26ReferenceStorageTypeLayout = global {{.*}} [[CREATE_GENERIC_METADATA:@create_generic_metadata[0-9.]*]]
// CHECK: define private %swift.type* [[CREATE_GENERIC_METADATA]]
struct ReferenceStorageTypeLayout<T> {
  var z: T

  // -- Known-Swift-refcounted type
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXoBo, i32 17)
  unowned(safe)   var cs:  C
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXuBo, i32 17)
  unowned(unsafe) var cu:  C
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXwGSqBo_, i32 17)
  weak            var cwo: C?
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXwGSqBo_, i32 17)
  weak            var cwi: C!

  // -- Open-code layout for protocol types with witness tables.
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_16_8_7fffffff_bt, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_8_4_1000_bt, i32 0, i32 0)
  unowned(safe)   var ps:  P
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_16_8_7fffffff_pod, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_8_4_1000_pod, i32 0, i32 0)
  unowned(unsafe) var pu:  P
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_16_8_7fffffff, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([3 x i8*], [3 x i8*]* @type_layout_8_4_0, i32 0, i32 0)
  weak            var pwo: P?
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_16_8_7fffffff, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([3 x i8*], [3 x i8*]* @type_layout_8_4_0, i32 0, i32 0)
  weak            var pwi: P!

  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_24_8_7fffffff_bt, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_12_4_1000_bt, i32 0, i32 0)
  unowned(safe)   var pqs:  protocol<P, Q>
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_24_8_7fffffff_pod, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_12_4_1000_pod, i32 0, i32 0)
  unowned(unsafe) var pqu:  protocol<P, Q>
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_24_8_7fffffff, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([3 x i8*], [3 x i8*]* @type_layout_12_4_0, i32 0, i32 0)
  weak            var pqwo: protocol<P, Q>?
  // CHECK-64: store i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @type_layout_24_8_7fffffff, i32 0, i32 0)
  // CHECK-32: store i8** getelementptr inbounds ([3 x i8*], [3 x i8*]* @type_layout_12_4_0, i32 0, i32 0)
  weak            var pqwi: protocol<P, Q>!

  // -- Unknown-refcounted existential without witness tables.
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXo[[UNKNOWN:B[Oo]]], i32 17)
  unowned(safe)   var aos:  AnyObject
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXu[[UNKNOWN]], i32 17)
  unowned(unsafe) var aou:  AnyObject
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXwGSq[[UNKNOWN]]_, i32 17)
  weak            var aowo: AnyObject?
  // CHECK: store i8** getelementptr inbounds (i8*, i8** @_TWVXwGSq[[UNKNOWN]]_, i32 17)
  weak            var aowi: AnyObject!
}