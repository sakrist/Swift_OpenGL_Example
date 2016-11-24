//
//  MatrixTransform.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 30/12/2015.
//
//

#if os(Linux)
    import Glibc
#elseif os(OSX)
    import Darwin.C
#endif

import utils


public let PI = 3.14159265358979323846264338327950288

func degreesToRadians(_ degrees:Float) -> Float {
    return degrees * (Float(PI) / 180)
}

public struct vector_float3 {
    public var v: (Float, Float, Float)
    
    private var array: [Float] {
        return [v.0, v.1, v.2]
    }
    
    subscript (index: Int) -> Float {
        get {
            return array[index]
        }
        set(newValue) {
            var _array = self.array
            _array[index] = newValue
            v = (_array[0], _array[1], _array[2])
        }
    }
    
    public init(_ __x:Float, _ __y:Float, _ __z:Float) {
        self.v = (__x,__y,__z)
    }
    public init(_ __var:Float) {
        self.v = (__var,__var,__var)
    }
    
    public func cross(_ vectorRight:vector_float3) -> vector_float3 {
        return vector_float3( self.v.1 * vectorRight.v.2 - self.v.2 * vectorRight.v.1,
            self.v.2 * vectorRight.v.0 - self.v.0 * vectorRight.v.2,
            self.v.0 * vectorRight.v.1 - self.v.1 * vectorRight.v.0 );
    }
    
    public func length() -> Float {
        return sqrtf(v.0 * v.0 + v.1 * v.1 + v.2 * v.2);
    }
    
     func scale(_ s:Float) -> vector_float3 {
        return vector_float3(v.0 * s, v.1 * s, v.2 * s)
    }
    
    public func normalize() -> vector_float3 {
        let s = 1.0 / self.length();
        return self.scale(s)
    }
}

func -(vectorLeft:vector_float3, vectorRight:vector_float3) -> vector_float3 {
    return vector_float3( vectorLeft.v.0 - vectorRight.v.0, vectorLeft.v.1 - vectorRight.v.1 , vectorLeft.v.2 - vectorRight.v.2 );
}


extension vector_float3 {
    public var x: Float { get { return self[0] } set(x) { self[0] = x } }
    public var y: Float { get { return self[1] } set(y) { self[1] = y } }
    public var z: Float { get { return self[2] } set(z) { self[2] = z } }
}

public typealias float3 = vector_float3

public struct vector_float4 {
    public var v: (Float, Float, Float, Float)
    
    private var array: [Float] {
        return [v.0, v.1, v.2, v.3]
    }
    
    subscript (index: Int) -> Float {
        get {
            return array[index]
        }
        set(newValue) {
            var _array = self.array
            _array[index] = newValue
            v = (_array[0], _array[1], _array[2], _array[3])
        }
    }
    
    public init(_ __x:Float, _ __y:Float, _ __z:Float, _ __w:Float) {
        self.v = (__x, __y, __z, __w)
    }
    public init(_ __var:Float) {
        self.v = (__var, __var, __var, __var)
    }
    public init(_ f3:float3, _ _w:Float) {
        self.v = (f3.v.0, f3.v.1, f3.v.2, _w)
    }
}

extension vector_float4 {
    public var x: Float { get { return self[0] } set(x) { self[0] = x } }
    public var y: Float { get { return self[1] } set(y) { self[1] = y } }
    public var z: Float { get { return self[2] } set(z) { self[2] = z } }
    public var w: Float { get { return self[3] } set(w) { self[3] = w } }
    public var xyz: float3 { get { return float3(v.0, v.1, v.2) } set(f3) { self.v = (f3.v.0, f3.v.1, f3.v.2, self.v.3) } }
}
public typealias float4 = vector_float4

public typealias quat = vector_float4


public struct matrix_float3x3 {
    public var columns: (float3, float3, float3)
    public init(_ m: (float3, float3, float3)) {
        self.columns = m
    }
    
    public init() {
        self.columns = (float3(0.0), float3(0.0), float3(0.0))
    }
    
    public init(_ m:matrix_float3x3) {
        self.columns = m.columns
    }
    var array: [float3] {
        return [columns.0, columns.1, columns.2]
    }
    
    subscript (index: Int) -> float3 {
        get {
            return array[index]
        }
        set(newValue) {
            var _array = self.array
            _array[index] = newValue
            columns = (_array[0], _array[1], _array[2])
        }
    }
}

public typealias float3x3 = matrix_float3x3


public struct matrix_float4x4 {
    public var columns: (float4, float4, float4, float4)
    public init(_ m: (float4, float4, float4, float4 )) {
        self.columns = m
    }
    
    public init(_ m0: Float, _ m1: Float, _ m2: Float, _ m3: Float,
        _ m4: Float, _ m5: Float, _ m6: Float, _ m7: Float,
        _ m8: Float, _ m9: Float, _ m10: Float, _ m11: Float,
        _ m12: Float, _ m13: Float, _ m14: Float, _ m15: Float) {
        self.columns = ( float4(m0,m1,m2,m3), float4(m4,m5,m6,m7), float4(m8,m9,m10,m11), float4(m12,m13,m14,m15) )
    }
    
    public init() {
        self.columns = (float4(0.0), float4(0.0), float4(0.0), float4(0.0))
    }
    
    public init(_ m:matrix_float4x4) {
        self.columns = m.columns
    }
    
    var array: [float4] {
        return [columns.0, columns.1, columns.2, columns.3]
    }
    
    subscript (index: Int) -> float4 {
        get {
            return array[index]
        }
        set(newValue) {
            var _array = self.array
            _array[index] = newValue
            columns = (_array[0], _array[1], _array[2], _array[3])
        }
    }
}

public typealias float4x4 = matrix_float4x4



let matrix_identity_float4x4:float4x4 =
    float4x4(float4(1.0, 0.0, 0.0, 0.0),
    float4(0.0, 1.0, 0.0, 0.0),
    float4(0.0, 0.0, 1.0, 0.0),
    float4(0.0, 0.0, 0.0, 1.0))

let matrix_identity_float3x3:float3x3 =
    float3x3(float3(1.0, 0.0, 0.0),
    float3(0.0, 1.0, 0.0),
    float3(0.0, 0.0, 1.0))

func matrix_from_columns(_ c0:float4, _ c1:float4, _ c2: float4, _ c3: float4) -> float4x4 {
    return float4x4(c0, c1, c2, c3)
}


func matrix_from_columns(_ c0:float3, _ c1:float3, _ c2: float3) -> float3x3 {
    return float3x3(c0, c1, c2)
}

func matrix_from_rows(_ c0:float3, _ c1:float3, _ c2: float3) -> float3x3 {
    return float3x3(float3(c0.x, c1.x, c2.x), float3(c0.y, c1.y, c2.y), float3(c0.z, c1.z, c2.z))
}

// multiply

func *(_ left: Float, right: float3) -> float3 {
    var result:float3 = right
    result.x = result.x * left
    result.y = result.y * left
    result.z = result.z * left
    return result
}

func *(_ matrixLeft: float4x4, matrixRight: float4x4) -> float4x4 {

    var m = float4x4(matrix_identity_float4x4)
    
    m[0].x  = matrixLeft[0].x * matrixRight[0].x  + matrixLeft[1].x * matrixRight[0].y  + matrixLeft[2].x * matrixRight[0].z   + matrixLeft[3].x * matrixRight[0].w
    m[1].x  = matrixLeft[0].x * matrixRight[1].x  + matrixLeft[1].x * matrixRight[1].y  + matrixLeft[2].x * matrixRight[1].z   + matrixLeft[3].x * matrixRight[1].w
    m[2].x  = matrixLeft[0].x * matrixRight[2].x  + matrixLeft[1].x * matrixRight[2].y  + matrixLeft[2].x * matrixRight[2].z  + matrixLeft[3].x * matrixRight[2].w
    m[3].x = matrixLeft[0].x * matrixRight[3].x + matrixLeft[1].x * matrixRight[3].y + matrixLeft[2].x * matrixRight[3].z  + matrixLeft[3].x * matrixRight[3].w
    
    m[0].y  = matrixLeft[0].y * matrixRight[0].x  + matrixLeft[1].y * matrixRight[0].y  + matrixLeft[2].y * matrixRight[0].z   + matrixLeft[3].y * matrixRight[0].w
    m[1].y  = matrixLeft[0].y * matrixRight[1].x  + matrixLeft[1].y * matrixRight[1].y  + matrixLeft[2].y * matrixRight[1].z   + matrixLeft[3].y * matrixRight[1].w
    m[2].y  = matrixLeft[0].y * matrixRight[2].x  + matrixLeft[1].y * matrixRight[2].y  + matrixLeft[2].y * matrixRight[2].z  + matrixLeft[3].y * matrixRight[2].w
    m[3].y = matrixLeft[0].y * matrixRight[3].x + matrixLeft[1].y * matrixRight[3].y + matrixLeft[2].y * matrixRight[3].z  + matrixLeft[3].y * matrixRight[3].w
    
    m[0].z  = matrixLeft[0].z * matrixRight[0].x  + matrixLeft[1].z * matrixRight[0].y  + matrixLeft[2].z * matrixRight[0].z  + matrixLeft[3].z * matrixRight[0].w
    m[1].z  = matrixLeft[0].z * matrixRight[1].x  + matrixLeft[1].z * matrixRight[1].y  + matrixLeft[2].z * matrixRight[1].z  + matrixLeft[3].z * matrixRight[1].w
    m[2].z = matrixLeft[0].z * matrixRight[2].x  + matrixLeft[1].z * matrixRight[2].y  + matrixLeft[2].z * matrixRight[2].z + matrixLeft[3].z * matrixRight[2].w
    m[3].z = matrixLeft[0].z * matrixRight[3].x + matrixLeft[1].z * matrixRight[3].y + matrixLeft[2].z * matrixRight[3].z + matrixLeft[3].z * matrixRight[3].w
    
    m[0].w  = matrixLeft[0].w * matrixRight[0].x  + matrixLeft[1].w * matrixRight[0].y  + matrixLeft[2].w * matrixRight[0].z  + matrixLeft[3].w * matrixRight[0].w
    m[1].w  = matrixLeft[0].w * matrixRight[1].x  + matrixLeft[1].w * matrixRight[1].y  + matrixLeft[2].w * matrixRight[1].z  + matrixLeft[3].w * matrixRight[1].w
    m[2].w = matrixLeft[0].w * matrixRight[2].x  + matrixLeft[1].w * matrixRight[2].y  + matrixLeft[2].w * matrixRight[2].z + matrixLeft[3].w * matrixRight[2].w
    m[3].w = matrixLeft[0].w * matrixRight[3].x + matrixLeft[1].w * matrixRight[3].y + matrixLeft[2].w * matrixRight[3].z + matrixLeft[3].w * matrixRight[3].w
    
    return m
}

func *=(_ matrixLeft: inout float4x4, matrixRight: float4x4) {
    matrixLeft = (matrixLeft * matrixRight)
}

func length(_ vector:float3) -> Float {
    return sqrtf(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
}

func normalize(_ vector:float3) -> float3 {
    let scale = 1.0 / length(vector)
    let v = float3( vector.x * scale, vector.y * scale, vector.z * scale )
    return v
}


func xRotation(_ radians:Float) -> float4x4 {
    let cos = cosf(radians)
    let sin = sinf(radians)
    let m = float4x4( 1.0, 0.0, 0.0, 0.0,
        0.0, cos, sin, 0.0,
        0.0, -sin, cos, 0.0,
        0.0, 0.0, 0.0, 1.0 )
    return m
}

func yRotation(_ radians:Float) -> float4x4 {
    let cos = cosf(radians)
    let sin = sinf(radians)
    let m = float4x4( cos, 0.0, -sin, 0.0,
        0.0, 1.0, 0.0, 0.0,
        sin, 0.0, cos, 0.0,
        0.0, 0.0, 0.0, 1.0 )
    return m
}

func zRotation(_ radians:Float) -> float4x4 {
    let cos = cosf(radians);
    let sin = sinf(radians);
    let m = float4x4(cos, sin, 0.0, 0.0,
        -sin, cos, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0 )
    return m
}


func perspective(_ fovyRadians:Float, aspect:Float , nearZ:Float , farZ:Float ) -> float4x4 {
    let yScale:Float = 1.0 / tanf(fovyRadians * 0.5)
    let xScale:Float = yScale / aspect
    
    var P = float4(0.0)
    var Q = float4(0.0)
    var R = float4(0.0)
    var S = float4(0.0)
    
    P.x = xScale
    Q.y = yScale
    R.z = (farZ + nearZ) / (nearZ - farZ)
    R.w = -1.0
    S.z = (2.0 * farZ * nearZ) / (nearZ - farZ)
    
    return float4x4(matrix_from_columns(P, Q, R, S))
}

func perspective(_ fovy:Float, width:Float, height:Float, near:Float, far:Float) -> float4x4 {
    let aspect = width / height
    return perspective(fovy, aspect:aspect, nearZ:near, farZ:far)
}

// scale
func scale(_ s:float3) -> float4x4 {
    var m = float4x4(matrix_identity_float4x4)
    m[0].x = s.x
    m[1].y = s.y
    m[2].z = s.z
    return m
}

// scale
func scale(_ x:Float, y:Float, z:Float) -> float4x4 {
    return scale(float3(x, y, z))
}

// translate
func translate(_ t:float3) -> float4x4 {
    var m = float4x4(matrix_identity_float4x4)
    m[3].x = t.x
    m[3].y = t.y
    m[3].z = t.z
    return m
}

// translate
func translate( x:Float, y:Float, z:Float) -> float4x4 {
    return translate(float3(x,y,z))
}


// rotate
func rotate(_ angleRadians:Float, r:float3) -> float4x4 {
    let a:Float = angleRadians
    let c:Float = cosf(a)
    let s:Float = sinf(a)
    
    let k:Float = 1.0 - c
    
    var u:float3 = normalize(r)
    var v:float3 = s * u
    var w:float3 = k * u
    
    var P = float4(0.0)
    var Q = float4(0.0)
    var R = float4(0.0)
    var S = float4(0.0)
    
    P.x = w.x * u.x + c
    P.y = w.x * u.y + v.z
    P.z = w.x * u.z - v.y
    
    Q.x = w.x * u.y - v.z
    Q.y = w.y * u.y + c
    Q.z = w.y * u.z + v.x
    
    R.x = w.x * u.z + v.y
    R.y = w.y * u.z - v.x
    R.z = w.z * u.z + c
    
    S.w = 1.0
    
    return float4x4(matrix_from_columns(P, Q, R, S))
}

// rotate
func rotate(_ angleRadians:Float, x:Float, y:Float, z:Float) -> float4x4
{
    let r = float3(x, y, z)
    return rotate(angleRadians, r:r)
}


// Construct a float 3x3 matrix from a 4x4 matrix
func float4x4to3x3( transpose:Bool, _ m:float4x4) -> float3x3
{
    let P:float3 = m[0].xyz
    let Q:float3 = m[1].xyz
    let R:float3 = m[2].xyz
    
    var mat:float3x3
    if transpose {
        mat = float3x3(matrix_from_rows(P, Q, R))
    } else {
        mat = float3x3(matrix_from_columns(P, Q, R))
    }
    
    return mat
}


func transpose(_ matrix:float3x3) -> float3x3
{
    var result:float3x3 = matrix;
    
    result[0].y = matrix[1].x;
    result[0].z = matrix[2].x;
    result[1].x = matrix[0].y;
    result[1].z = matrix[2].y;
    result[2].x = matrix[0].z;
    result[2].y = matrix[1].z;
    
    return result;
}

func scale(_ matrix:float3x3, sx:Float, sy:Float, sz:Float) -> float3x3
{
    let m = float3x3( float3(matrix[0].x * sx, matrix[0].y * sx, matrix[0].z * sx),
        float3(matrix[1].x * sy, matrix[1].y * sy, matrix[1].z * sy),
        float3(matrix[2].x * sz, matrix[2].y * sz, matrix[2].z * sz ));
    return m;
}

func invert(_ matrix:float3x3, isInvertible: inout Bool) -> float3x3 {
    let determinant:Float = (matrix[0].x * (matrix[1].y * matrix[2].z - matrix[1].z * matrix[2].y)) +
        (matrix[0].y * (matrix[1].z * matrix[2].x - matrix[2].z * matrix[1].x)) +
        (matrix[0].z * (matrix[1].x * matrix[2].y - matrix[1].y * matrix[2].x));
    
    let canInvert:Bool = (determinant != 0.0);
    if (isInvertible) {
        isInvertible = canInvert;
    }
    
    if (!canInvert) {
        return matrix_identity_float3x3;
    }
    
    return scale(transpose(matrix), sx:determinant, sy:determinant, sz:determinant);
}

// Source of trackball
// http://fossies.org/linux/privat/gfsview-snapshot-121130.tar.gz:a/gfsview-snapshot-121130/gl/trackball.c


func tb_project_to_sphere(_ r:Float, _ x:Float, _ y:Float) -> Float
{
    var d:Float, t:Float, z:Float
    
    d = sqrtf(x*x + y*y)
    if d < (r * 0.70710678118654752440) {    /* Inside sphere */
        z = sqrtf(r*r - d*d)
    } else {           /* On hyperbola */
        t = r / 1.41421356237309504880
        z = t*t / d
    }
    return z
}

func trackball(_ start:Point, end:Point, trackSize:Float) -> quat
{
    var quat_result:quat
    
    var a:float3 /* Axis of rotation */
    var phi:Float  /* how much to rotate about axis */
    var p1:float3, p2:float3, d:float3
    var t:Float
    
    if start.x == end.x && start.y == end.y {
        quat_result = quat(0, 0, 0, 1.0)
        return quat_result
    }
    
    /*
    * First, figure out z-coordinates for projection of P1 and P2 to
    * deformed sphere
    */
    p1 = float3(Float(start.x), Float(start.y), tb_project_to_sphere(trackSize, Float(start.x), Float(start.y)))
    p2 = float3(Float(end.x), Float(end.y), tb_project_to_sphere(trackSize, Float(end.x), Float(end.y)))
    
    /*
    *  Now, we want the cross product of P1 and P2
    */
    a = p2.cross(p1)
    
    /*
    *  Figure out how much to rotate around that axis.
    */
    d = p1 - p2
    t = d.length() / (2.0*trackSize)
    
    /*
    * Avoid problems with out-of-control values...
    */
    if t > 1.0 {
        t = 1.0
    }
    if t < -1.0 {
        t = -1.0
    }
    phi = 2.0 * asinf(t)
    
    
    a = a.normalize()
    a = a.scale(sinf(phi/2.0))
    quat_result = quat(a, cosf(phi/2.0))
    
    return quat_result
}


func rotationMatrix(_ q:quat) -> float4x4 {
    
    var m = matrix_identity_float4x4
    
    m[0].x = 1.0 - 2.0 * (q[1] * q[1] + q[2] * q[2])
    m[0].y = 2.0 * (q[0] * q[1] - q[2] * q[3])
    m[0].z = 2.0 * (q[2] * q[0] + q[1] * q[3])
    
    m[1].x = 2.0 * (q[0] * q[1] + q[2] * q[3])
    m[1].y = 1.0 - 2.0 * (q[2] * q[2] + q[0] * q[0])
    m[1].z = 2.0 * (q[1] * q[2] - q[0] * q[3])

    m[2].x = 2.0 * (q[2] * q[0] - q[1] * q[3])
    m[2].y = 2.0 * (q[1] * q[2] + q[0] * q[3])
    m[2].z = 1.0 - 2.0 * (q[1] * q[1] + q[0] * q[0])
    
    return m
}

