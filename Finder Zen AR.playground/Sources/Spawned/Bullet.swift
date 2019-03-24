import SceneKit

fileprivate let emitter = SCNParticleSystem(named: "bullet.scnp", inDirectory: nil)!

public class Bullet: SCNNode {
    
    /// The spawn point of the `Bullet`, relative to `pointOfView`
    public static let relativeSpawnPoint = SCNVector3(0.02, -0.02, -0.02)
    
    // MARK: - Constants
    
    private let radius: CGFloat = 0.02
    private let sphere: SCNSphere
    
    private let speedScalar: Float = 8.0
    private let lifetime: TimeInterval = 1.5
    
    // MARK: - Instance properties
    
    public var isReflected: Bool { return self.isReflectedInternal }
    private var isReflectedInternal = false
    
    // MARK: - Instance methods
    
    public init(position: SCNVector3, direction: SCNVector3) {
        
        self.sphere = SCNSphere(radius: self.radius)
        super.init()
        
        self.position = position
        
        self.geometry = sphere
        self.geometry?.firstMaterial?.blendMode = .add
        
        // Initialize particle system
        
        let particleSystem = emitter.copy() as! SCNParticleSystem
        self.addParticleSystem(particleSystem)
        
        self.setReflect(to: isModifyBulletCheatOn)  // Sets up emitter and physicsBody
        
        // Run
        
        //self.physicsBody?.velocity = direction * self.speedScalar
        self.runAction(.sequence([
            .move(
                by: direction * self.speedScalar * Float(self.lifetime),
                duration: self.lifetime
            ),
            .removeFromParentNode(),
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        self.physicsBody = SCNPhysicsBody(
            type: .kinematic,  //.dynamic,
            shape: SCNPhysicsShape(geometry: self.sphere, options: nil)
        )
        
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.damping = 0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.continuousCollisionDetectionThreshold = self.sphere.radius * 2
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.bullet
        self.physicsBody?.collisionBitMask = 0  //CategoryBitMasks.wall
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.allBubbles | CategoryBitMasks.wall | CategoryBitMasks.platform
    }
    
    private func setupEmitter(_ particleSystem: SCNParticleSystem?) {
        particleSystem?.blendMode = .additive
        particleSystem?.particleLifeSpan = 0.2
        particleSystem?.particleLifeSpanVariation = 0.2
        particleSystem?.birthRate = 960
        
        particleSystem?.particleColor = (!self.isReflected) ? #colorLiteral(red: 0.2161641725, green: 0.1039007482, blue: 0.5607843399, alpha: 1) : #colorLiteral(red: 0.9486960827, green: 0.737868618, blue: 0.2279654489, alpha: 1)
    }
    
    public func setReflect(to value: Bool) {
        self.isReflectedInternal = value
        
        func setupParticleAnimation(fromValue: Any, toValue: Any) {
            let sizeAnimation = CABasicAnimation()
            sizeAnimation.fromValue = fromValue
            sizeAnimation.toValue = toValue
            
            let opacityAnimation = CABasicAnimation()
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            
            self.particleSystems?.first?.propertyControllers = [
                .size: SCNParticlePropertyController(animation: sizeAnimation),
                .opacity: SCNParticlePropertyController(animation: opacityAnimation),
            ]
        }
        
        if self.isReflected {
            let newRadius: CGFloat = 0.06
            self.sphere.radius = newRadius
            
            setupParticleAnimation(
                fromValue: 1.0 * newRadius / self.radius,
                toValue: 0.4 * newRadius / self.radius
            )
        } else {
            self.sphere.radius = self.radius
            setupParticleAnimation(fromValue: 1.0, toValue: 0.4)
        }
        
        self.setupEmitter(self.particleSystems?.first)
        self.setupPhysicsBody()
    }
    
    public func reflect() {
        guard !self.isReflected, let parentNode = self.parent else { return }
        
        let upward = SCNVector3(0, 0.7, 0)
        let downward = SCNVector3(0, -0.7, 0)
        
        let _ = [
            Bullet(position: self.presentation.position, direction: upward),
            Bullet(position: self.presentation.position, direction: downward),
        ].map {
            parentNode.addChildNode($0)
            $0.setReflect(to: true)
        }
        
        self.removeFromParentNode()
    }
    
    public func destroy() {
        self.parent?.addChildNode(Effect(
            emitter: emitter.copy() as! SCNParticleSystem,
            spawnDuration: 0.1,
            location: self.presentation.position,
            modifications: { particleSystem in
                self.setupEmitter(particleSystem)
                particleSystem.particleVelocity = 0.1
                particleSystem.particleVelocityVariation = 0.1
                
                particleSystem.particleLifeSpan = 0.3
                particleSystem.particleLifeSpanVariation = 0.3
                
                let sizeAnimation = CABasicAnimation()
                sizeAnimation.fromValue = 1.0
                sizeAnimation.toValue = 4.0
                
                particleSystem.propertyControllers = [
                    .size: SCNParticlePropertyController(animation: sizeAnimation),
                ]
            }
        ))
        self.removeFromParentNode()
    }
}
