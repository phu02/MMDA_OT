//: Playground - noun: a place where people can play

import UIKit
import Foundation
import Accelerate


let a: [Float] = [1, 2, 4]
let b: [Float] = [3, 4, 3]
var c: [Float] = [0, 0, 0]

print("string")
/*
func vDSP_vmul(__A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length)
*/

vDSP_vmul(a, 1, b, 1, &c, 1, vDSP_Length(3))

print("\(c[0]) \(c[1]) \(c[2])")

print("string")
/*
func vDSP_vadd(__A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length)
*/
vDSP_vadd(a, 1, b, 1, &c, 1, vDSP_Length(3))

print("\(c[0]) \(c[1]) \(c[2])")

func myPtr1(p: UnsafePointer<Float>) {
    // ...
}


func myPtr2(p: UnsafeMutablePointer<Float>) {
    // ...
}

let fa: [Float] = [1.0, 2.0, 3.0, 4.0]

myPtr1(fa)
myPtr2(UnsafeMutablePointer(fa))



func takesAVoidPointer(x: UnsafePointer<Void>)  {
    // ...
}

var xa: Float = 0.0, y: Int = 0
var pa: UnsafePointer<Float> = nil, q: UnsafePointer<Int> = nil
takesAVoidPointer(nil)
takesAVoidPointer(pa)
takesAVoidPointer(q)
takesAVoidPointer(&xa)
takesAVoidPointer(&y)
takesAVoidPointer([1.0, 2.0, 3.0] as [Float])
let intArray = [1, 2, 3]
takesAVoidPointer(intArray)



func takesAPointer(x: UnsafePointer<Float>) {
    // ...
}

var xup: Float = 0.0
var pup: UnsafePointer<Float> = nil
takesAPointer(nil)
takesAPointer(pup)
takesAPointer(&xup)
takesAPointer([1.0, 2.0, 3.0])



func takesAMutablePointer(x: UnsafeMutablePointer<Float>) {
    // ...
}

var x: Float = 0.0
var p: UnsafeMutablePointer<Float> = nil
let aa: [Float] = [1.0, 2.0, 3.0]
takesAMutablePointer(nil)
takesAMutablePointer(p)
takesAMutablePointer(&x)
takesAMutablePointer(UnsafeMutablePointer(aa))



func takesAMutableVoidPointer(x: UnsafeMutablePointer<Void>)  {
    // ...
}


var xmv: Float = 0.0, ymv: Int = 0
var pmv: UnsafeMutablePointer<Float> = nil, qmv: UnsafeMutablePointer<Int> = nil
var amv: [Float] = [1.0, 2.0, 3.0], bmv: [Int] = [1, 2, 3]
takesAMutableVoidPointer(nil)
takesAMutableVoidPointer(pmv)
takesAMutableVoidPointer(qmv)
takesAMutableVoidPointer(&xmv)
takesAMutableVoidPointer(&ymv)
takesAMutableVoidPointer(&amv)
takesAMutableVoidPointer(&bmv)




