include vector3

type 
    Bivector3* = object
        b01: float
        b02: float
        b12: float  
    
    Rotor3* = object
        c: float
        b01: float
        b02: float
        b12: float

proc bivector3*(b01, b02, b12: float): Bivector3 =
    result.b01 = b01
    result.b02 = b02
    result.b12 = b12


proc wedge*(u, v: Vec3f): Bivector3 =
    result.b01 = u[0]*v[1] - u[1]*v[0]
    result.b02 = u[0]*v[2] - u[2]*v[0]
    result.b12 = u[1]*v[2] - u[2]*v[1]

# Rotor

proc len*(r: Rotor3): float =
    return sqrt(r.c^2 + r.b01^2 + r.b02^2 + r.b12^2)

proc normalize*(r: var Rotor3): Rotor3 =
    let l = len(r)
    r.c = r.c/l
    r.b01 = r.b01/l
    r.b02 = r.b02/l
    r.b12 = r.b12/l
    return r

proc normal*(r: Rotor3): Rotor3 =
    var r_normal = r
    return r_normal.normalize

proc rotor3*(c, b01, b02, b12: float): Rotor3 =
    result.c = c
    result.b01 = b01
    result.b02 = b02
    result.b12 = b12


proc rotor3*(c: float, bivector: Bivector3): Rotor3 =
    result.c = c
    result.b01 = bivector.b01
    result.b02 = bivector.b02
    result.b12 = bivector.b12

proc rotor3*(v_from, v_to: Vec3f): Rotor3 =
    let minus_b = wedge(v_to, v_from)
    result.c = 1 + dot(v_from, v_to)
    result.b01 = minus_b.b01
    result.b02 = minus_b.b02
    result.b12 = minus_b.b12
    result.normalize


proc rotor3*(bivector_plane: Bivector3, angle_rad: float): Rotor3 =
    let sin_c = sin(angle_rad / 2.0)
    
    result.c = cos(angle_rad / 2.0)
    result.b01 = -sin_c * bivector_plane.b01
    result.b02 = -sin_c * bivector_plane.b02
    result.b12 = -sin_c * bivector_plane.b12

proc `*`*(p, q: Rotor3): Rotor3 =
    result.c = p.c * q.c - p.b01 * q.b01 - p.b02 * q.b02 - p.b12 * q.b12
    result.b01 = p.b01 * q.c + p.c * q.b01 + p.b12 * q.b02 - p.b02 * q.b12
    result.b02 = p.b02 * q.c + p.c * q.b02 - p.b12 * q.b01 + p.b01 * q.b12
    result.b12 = p.b12 * q.c + p.c * q.b12 + p.b02 * q.b01 - p.b01 * q.b02

proc `*=`*(p: var Rotor3, q: Rotor3): Rotor3 =
    p = p * q

proc reverse*(r: Rotor3): Rotor3 =
    return rotor3(r.c, -r.b01, -r.b02, -r.b12)

proc rotate*(p, q: Rotor3): Rotor3 =
    return p * q * reverse(p)

proc rotate*(r: Rotor3, v: Vec3f): Vec3f =
    var 
        q, p: Vec3f
    # Matrix multiplicatio
    q[0] = r.c * v[0] + v[1] * r.b01 + v[2] * r.b02
    q[1] = r.c * v[1] - v[0] * r.b01 + v[2] * r.b12
    q[2] = r.c * v[2] - v[0] * r.b02 - v[1] * r.b12

    # echo fmt"q: {$q}"

    let q_tri = v[0] * r.b12 - v[1] * r.b02 + v[2] * r.b01

    # echo fmt"q_tri: {q_tri}"
    # Matrix multiplication the sequel
    p[0] = r.c * q[0] + q[1] * r.b01  + q[2] * r.b02  + q_tri * r.b12
    p[1] = r.c * q[1] - q[0] * r.b01  - q_tri * r.b12 + q[2] * r.b12
    p[2] = r.c * q[2] + q_tri * r.b02 - q[1] * r.b12  - q[1] * r.b12

    return p



 