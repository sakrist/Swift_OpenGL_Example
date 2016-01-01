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


public struct vector_float3 {
    public var v: (Float, Float, Float)
    
    var array: [Float] {
        let arrayFloats: [Float] = [v.0, v.1, v.2]
        return arrayFloats
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
}
extension vector_float3 {
    public var x: Float { get { return self[0] } set(x) { self[0] = x } }
    public var y: Float { get { return self[1] } set(y) { self[1] = y } }
    public var z: Float { get { return self[2] } set(z) { self[2] = z } }
}

public typealias float3 = vector_float3

public struct vector_float4 {
    public var v: (Float, Float, Float, Float)
    
    var array: [Float] {
        let arrayFloats: [Float] = [v.0, v.1, v.2, v.3]
        return arrayFloats
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
}

extension vector_float4 {
    public var x: Float { get { return self[0] } set(x) { self[0] = x } }
    public var y: Float { get { return self[1] } set(y) { self[1] = y } }
    public var z: Float { get { return self[2] } set(z) { self[2] = z } }
    public var w: Float { get { return self[3] } set(w) { self[3] = w } }
}
public typealias float4 = vector_float4


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


let matrix_identity_float4x4:(float4, float4, float4, float4) =
    (float4(1.0, 0.0, 0.0, 0.0),
    float4(0.0, 1.0, 0.0, 0.0),
    float4(0.0, 0.0, 1.0, 0.0),
    float4(0.0, 0.0, 0.0, 1.0))

func matrix_from_columns(c0:float4, _ c1:float4, _ c2: float4, _ c3: float4) -> float4x4 {
    return float4x4(c0, c1, c2, c3)
}


func matrix_from_columns(c0:float3, _ c1:float3, _ c2: float3) -> float3x3 {
    return float3x3(c0, c1, c2)
}

func matrix_from_rows(c0:float3, _ c1:float3, _ c2: float3) -> float3x3 {
    return float3x3(float3(c0.x, c1.x, c2.x), float3(c0.y, c1.y, c2.y), float3(c0.z, c1.z, c2.z))
}

// multiply

func *(left: Float, right: float3) -> float3 {
    var result:float3 = right
    result.x = result.x * left
    result.y = result.y * left
    result.z = result.z * left
    return result
}

func *(matrixLeft: float4x4, matrixRight: float4x4) -> float4x4 {

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


func length(vector:float3) -> Float {
    return sqrtf(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
}

func normalize(vector:float3) -> float3 {
    let scale = 1.0 / length(vector)
    let v = float3( vector.x * scale, vector.y * scale, vector.z * scale )
    return v
}


func perspective(fovyRadians:Float, aspect:Float , nearZ:Float , farZ:Float ) -> float4x4 {
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

func perspective(fovy:Float, width:Float, height:Float, near:Float, far:Float) -> float4x4 {
    let aspect = width / height
    return perspective(fovy, aspect:aspect, nearZ:near, farZ:far)
}

// scale
func scale(s:float3) -> float4x4 {
    var m = float4x4(matrix_identity_float4x4)
    m[0].x = s.x
    m[1].y = s.y
    m[2].z = s.z
    return m
}

// scale
func scale(x:Float, y:Float, z:Float) -> float4x4 {
    return scale(float3(x, y, z))
}

// translate
func translate(t:float3) -> float4x4 {
    var m = float4x4(matrix_identity_float4x4)
    m[3].x = t.x
    m[3].y = t.y
    m[3].z = t.z
    return m
}

// translate
func translate(x:Float, y:Float, z:Float) -> float4x4 {
    return translate(float3(x,y,z))
}


// rotate
func rotate(angleRadians:Float, r:float3) -> float4x4 {
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
func rotate(angleRadians:Float, x:Float, y:Float, z:Float) -> float4x4
{
    let r = float3(x, y, z)
    return rotate(angleRadians, r:r)
}


// Construct a float 3x3 matrix from a 4x4 matrix
func float4x4to3x3( transpose:Bool, M:float4x4) -> float3x3
{
    let P:float3 = float3(M[0].x, M[0].y, M[0].z)
    let Q:float3 = float3(M[1].x, M[1].y, M[1].z)
    let R:float3 = float3(M[2].x, M[2].y, M[2].z)
    
    var mat:float3x3
    if transpose {
        mat = float3x3(matrix_from_rows(P, Q, R))
    } else {
        mat = float3x3(matrix_from_columns(P, Q, R))
    }
    
    return mat
}
