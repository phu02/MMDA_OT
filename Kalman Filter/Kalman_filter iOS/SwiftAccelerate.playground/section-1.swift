// https://github.com/haginile/SwiftAccelerate

import Accelerate

/**
*  Vector & Scalar
*/

var v = [1.0, 2.0]
var s = 3.0
var vsresult = [Double](count : v.count, repeatedValue : 0.0)
// func vDSP_vsaddD(__A: UnsafePointer<Double>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Double>, _ __C: UnsafeMutablePointer<Double>, _ __IC: vDSP_Stride, _ __N: vDSP_Length)
vDSP_vsaddD(v, 1, &s, &vsresult, 1, vDSP_Length(v.count))
vsresult

//multiply vector with scalar
vDSP_vsmulD(v, 1, &s, &vsresult, 1, vDSP_Length(v.count))
vsresult

vDSP_vsdivD(v, 1, &s, &vsresult, 1, vDSP_Length(v.count))
vsresult


/**
*  Vector & Vector
*/
var v1 = [2.0, 5.0]
var v2 = [3.0, 4.0]
var vvresult = [Double](count : 2, repeatedValue : 0.0)
vDSP_vaddD(v1, 1, v2, 1, &vvresult, 1, vDSP_Length(v1.count))
vvresult

// equals to matlab code .*
vDSP_vmulD(v1, 1, v2, 1, &vvresult, 1, vDSP_Length(v1.count))
vvresult

vDSP_vdivD(v1, 1, v2, 1, &vvresult, 1, vDSP_Length(v1.count))
vvresult


/**
*  Dot Product
*/
var v3 = [1.0, 2.0]
var v4 = [3.0, 4.0]
var dpresult = 0.0
vDSP_dotprD(v3, 1, v4, 1, &dpresult, vDSP_Length(v3.count))
dpresult


/**
*  Matrix Multiplication
*/
var m1 = [ 3.0, 2.0, 4.0, 5.0, 6.0, 7.0 ]
var m2 = [ 10.0, 20.0, 30.0, 30.0, 40.0, 50.0]
var mresult = [Double](count : 4, repeatedValue : 0.0)

vDSP_mmulD(m2, 1, m1, 1, &mresult, 1, 2, 2, 3)
mresult


/**
*  Matrix Inversion
*/
func invert(matrix : [Double]) -> [Double] {
    
    var inMatrix = matrix
    
    var N = __CLPK_integer(sqrt(Double(matrix.count)))
    
    var pivot : __CLPK_integer = 0
    var workspace = 0.0
    var error : __CLPK_integer = 0
    
    
    dgetrf_(&N, &N, &inMatrix, &N, &pivot, &error)
    
    error
    if error != 0 {
        return inMatrix
    }
    
    dgetri_(&N, &inMatrix, &N, &pivot, &workspace, &N, &error)
    return inMatrix
}

//var m = [1.0, 2.0, 3.0, 4.0]
//invert(m)



var n = [5.11, 0.0, 0.0, 0.0, 5.11, 0.0, 0.0, 0.0, 5.11]
invert(n)

/**
*  Matrix Transpose
*/

var t = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
var mtresult = [Double](count : t.count, repeatedValue : 0.0)
vDSP_mtransD(t, 1, &mtresult, 1, 3, 2)
mtresult
