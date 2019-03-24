import SceneKit

public func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

public func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

public func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

public func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func +=(lhs: inout SCNVector3, rhs: SCNVector3) {
    lhs = lhs + rhs
}

public func -=(lhs: inout SCNVector3, rhs: SCNVector3) {
    lhs = lhs - rhs
}

public func *=(lhs: inout SCNVector3, rhs: Float) {
    lhs = lhs * rhs
}

public func abs(_ v: SCNVector3) -> Float {
    return sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
}

public func abs(_ a: Float, _ b: Float) -> Float {
    return sqrt(a * a + b * b)
}

/// Get the absolute Y-angle of the line from one 3D position to another
public func getYAngle(from source: SCNVector3, to target: SCNVector3) -> Float {
    let deltaX = target.x - source.x
    let deltaZ = source.z - target.z
    return atan2(deltaZ, deltaX)
}
