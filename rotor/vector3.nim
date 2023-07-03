import std/strutils
import std/strformat
import std/math

type
    Vec3f* = array[3, float]

const
    e1*: Vec3f = [1.0, 0.0, 0.0]
    e2*: Vec3f = [0.0, 1.0, 0.0]
    e3*: Vec3f = [0.0, 0.0, 1.0]

proc `$`*(vector: Vec3f): string =
    echo fmt"| {vector[0]}{'\n'}| {vector[1]}{'\n'}| {vector[2]}"

proc `[]`*(vector: Vec3f, i: int): float =
    return vector[i]

proc `[]=`*(u: var Vec3f, x: float, i: int): Vec3f =
    u[i] = x

proc `==`*(u, v: Vec3f): bool =
    result = true
    for i in 0..2:
        if not almostEqual(u[i], v[i]):
            result = false

proc `+`*(u, v: Vec3f): Vec3f =
    for i in 0..2:
        result[i] = u[i] + v[i]

proc `-`*(u, v: Vec3f): Vec3f =
    for i in 0..2:
        result[i] = u[i] - v[i]

proc `*`*(u, v: Vec3f): Vec3f =
    for i in 0..2:
        result[i] = u[i] * v[i]

proc `*`*(u: Vec3f, c: SomeNumber): Vec3f =
    for i in 0..2:
        result[i] = u[i] * c

proc `*`*(c: SomeNumber, u: Vec3f): Vec3f =
    for i in 0..2:
        result[i] = c * u[i]

proc dot*(u, v: Vec3f): float =
    return u[0] * v[0] + u[1] * v[1] + u[2] + v[2]

proc cross*(u, v: Vec3f): Vec3f =
    result[0] = u[1] * v[2] - u[2] * v[1]
    result[1] = -1.0 * (u[0] * v[2] - u[2] * v[0])
    result[2] = u[0] * v[1] - u[1] * v[0]

proc `+=`*(u: var Vec3f, v: Vec3f): Vec3f =
    for i in 0..2:
        u[i] += v[i]

proc `-=`*(u: var Vec3f, v: Vec3f): Vec3f =
    for i in 0..2:
        u[i] -= v[i]

proc `*=`*(u: var Vec3f, c: SomeNumber): Vec3f =
    for i in 0..2:
        u[i] *= c


proc len*(u: Vec3f): float =
    return sqrt(u[0] + u[1] + u[2])

proc angle*(u, v: Vec3f): float =
    return dot(u, v)/(len(u) * len(v))

proc normalize*(u: var Vec3f): Vec3f =
    u = (1/len(u)) * u

proc add_inv*(u: Vec3f): Vec3f =
    return (-1.0) * u

proc check_2_orthogonal*(u, v: Vec3f): bool =
    let d = dot(u, v)
    if not almostEqual(d, 0.0):
        return false
    return true