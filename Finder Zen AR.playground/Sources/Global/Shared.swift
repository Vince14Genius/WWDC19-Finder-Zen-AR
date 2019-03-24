import SceneKit

public protocol ViewInitializable {
    func initialize()
}

public struct Actions {
    
    public static let breathingAnimation = SCNAction.repeatForever(.sequence([
        .scale(by: 1.1, duration: 2.5),
        .scale(by: CGFloat(1) / 1.1, duration: 3.5),
        ]))
    
    public static let finderJump = SCNAction.sequence([
        .moveBy(x: 0, y: 0.04, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0.03, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0.02, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0.01, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0, z: 0, duration: 0.05),
        .moveBy(x: 0, y: -0.01, z: 0, duration: 0.05),
        .moveBy(x: 0, y: -0.02, z: 0, duration: 0.05),
        .moveBy(x: 0, y: -0.03, z: 0, duration: 0.05),
        .moveBy(x: 0, y: -0.04, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0.01, z: 0, duration: 0.05),
        .moveBy(x: 0, y: 0, z: 0, duration: 0.05),
        .moveBy(x: 0, y: -0.01, z: 0, duration: 0.05),
        ])
}

extension SCNNode {
    public func letThereBeLight(type: SCNLight.LightType, intensity: CGFloat) {
        let lightSource = SCNLight()
        self.light = lightSource
        lightSource.type = type
        lightSource.intensity = intensity
    }
}
