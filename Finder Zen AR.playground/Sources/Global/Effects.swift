import SceneKit

public class Effect: SCNNode {
    public let emitter: SCNParticleSystem
    
    public init(emitter: SCNParticleSystem,
                spawnDuration: TimeInterval,
                location: SCNVector3,
                modifications: (SCNParticleSystem) -> ()) {
        
        self.emitter = emitter
        super.init()
        
        self.position = location
        self.addParticleSystem(emitter)
        
        modifications(emitter)
        
        self.runAction(.sequence([
            .wait(duration: spawnDuration),
            .removeFromParentNode(),
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
