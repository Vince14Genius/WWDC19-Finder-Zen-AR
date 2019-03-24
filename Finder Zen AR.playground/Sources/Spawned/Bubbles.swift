import SceneKit

fileprivate let emitter = SCNParticleSystem(named: "shatter.scnp", inDirectory: nil)!

extension GameArea {
    
    public static func randomSpawnPoint() -> SCNVector3 {
        func isWithinSpawnRange(using distance: Float) -> Bool {
            return GameArea.spawnRadiusMinimum < distance &&
                distance < GameArea.spawnRadiusMaximum
        }
        
        var generatedPoint: SCNVector3
        
        repeat {
            
            let x = cos(.random(in: 0...Float.pi)) * GameArea.spawnRadiusMaximum
            let y = sin(.random(in: 0...Float.pi)) * GameArea.spawnRadiusMaximum
            let z = sin(.random(in: 0...Float.pi)) * GameArea.spawnRadiusMaximum
            generatedPoint = SCNVector3(x, y, z)
            
        } while isWithinSpawnRange(using: abs(generatedPoint))
        
        return generatedPoint + GameArea.finderPosition
    }
}

public class Bubble: SCNNode {
    
    private let cbTextNode = SCNNode()
    private let cbSymbol = SCNText(string: nil, extrusionDepth: 0)
    
    private let sphere = SCNSphere(radius: 0.06)
    private let radius: CGFloat = 0.06
    
    fileprivate var material = SCNMaterial()
    
    fileprivate let shatterEffect = emitter.copy() as! SCNParticleSystem
    
    // MARK: - instance methods
    
    public init(from location: SCNVector3,
                to destination: SCNVector3,
                cbSymbol: String,
                lifetime: TimeInterval) {
        
        super.init()
        
        self.geometry = self.sphere
        self.sphere.materials = [self.material]
        self.material.lightingModel = .physicallyBased
        self.material.metalness.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.material.roughness.contents = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
    
        self.position = location
        
        // Set up colorblind aid text
        
        func centerText(_ text: SCNText) -> SCNVector3 {
            let min = text.boundingBox.min
            let max = text.boundingBox.max
            
            let halfWidth = (max.x - min.x) / 2
            let halfHeight = (max.y - min.y) / 2
            let halfLength = (max.z - min.z) / 2
            
            return SCNVector3(
                x: -halfWidth - min.x,
                y: -halfHeight - min.y,
                z: -halfLength - min.z
            )
        }
        
        self.addChildNode(self.cbTextNode)
        self.cbTextNode.geometry = self.cbSymbol
        self.cbSymbol.string = cbSymbol
        self.cbSymbol.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        self.cbSymbol.font = .systemFont(ofSize: 0.1)
        
        self.cbTextNode.position = centerText(self.cbSymbol)
        
        let cbMaterial = SCNMaterial()
        cbMaterial.isDoubleSided = true
        cbMaterial.diffuse.contents = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cbMaterial.blendMode = .replace
        self.cbSymbol.materials = [cbMaterial]
        
        self.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 1)))
        
        // Set up physics body
        
        self.physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: self.sphere, options: nil)
        )
        
        self.physicsBody?.continuousCollisionDetectionThreshold = self.radius * 2
        self.physicsBody?.collisionBitMask = 0
        
        // Run actions
        
        self.runAction(.sequence([
            .move(to: destination, duration: lifetime),
            .removeFromParentNode()
            ]))
        self.runAction(Actions.breathingAnimation)
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 0.1),
            .run { _ in self.cbTextNode.isHidden = !isColorblindModeOn },
            ])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func directHit() {
        self.destroy()
    }
    
    public func reflectedHit() {
        self.destroy()
    }
    
    public func destroy() {
        self.parent?.addChildNode(Effect(
            emitter: self.shatterEffect,
            spawnDuration: 0.1,
            location: self.presentation.position,
            modifications: { particleSystem in
                particleSystem.blendMode = .additive
                particleSystem.birthRate = 480
                
                particleSystem.particleVelocity = 0.4
                particleSystem.particleVelocityVariation = 0.4
                
                particleSystem.particleLifeSpan = 0.7
                particleSystem.particleLifeSpanVariation = 0.4
                
                let sizeAnimation = CABasicAnimation()
                sizeAnimation.fromValue = 1.0
                sizeAnimation.toValue = 2.5
                
                let opacityAnimation = CABasicAnimation()
                opacityAnimation.fromValue = 1.0
                opacityAnimation.toValue = 0.0
                
                particleSystem.propertyControllers = [
                    .size: SCNParticlePropertyController(animation: sizeAnimation),
                    .opacity: SCNParticlePropertyController(animation: opacityAnimation),
                ]
            }
        ))
        self.removeAllActions()
        self.removeFromParentNode()
    }
}

/**
 * Reach Finder: awards a point
 * Direct Hit: bubble removed
 * Reflected Hit: spawn extra blues
 */
public class BlueBubble: Bubble {
    
    private let cbSymbolText = "○"
    private let lifetime: TimeInterval = 4.0
    
    public init() {
        super.init(
            from: GameArea.randomSpawnPoint(),
            to: GameArea.finderPosition,
            cbSymbol: self.cbSymbolText,
            lifetime: self.lifetime
        )
        
        self.setup()
        
        self.runAction(.wait(duration: self.lifetime)) { GameArea.addScore(by: 1) }
    }
    
    public init(startPosition: SCNVector3) {
        let newLifeTime: TimeInterval = 0.8
        
        super.init(
            from: startPosition,
            to: GameArea.finderPosition,
            cbSymbol: self.cbSymbolText,
            lifetime: newLifeTime
        )
        
        self.setup()
        
        self.runAction(.wait(duration: newLifeTime)) { GameArea.addScore(by: 1) }
    }
    
    private func setup() {
        self.physicsBody?.categoryBitMask = CategoryBitMasks.bubbleBlue
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
        
        self.material.diffuse.contents = #colorLiteral(red: 0, green: 0, blue: 0.8053477113, alpha: 0.5)
        self.shatterEffect.particleColor = #colorLiteral(red: 0, green: 0, blue: 0.8053477113, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func reflectedHit() {
        guard let parentNode = self.parent else { fatalError("Orphan") }
        
        for i in 0...3 {
            var newPos = self.position
            newPos.x += .random(in: -0.06...0.06)
            newPos.y += .random(in: -0.06...0.06)
            newPos.z += .random(in: -0.06...0.06)
            
            parentNode.runAction(.sequence([
                .wait(duration: 0.1 * TimeInterval(i)),
                .run { _ in parentNode.addChildNode(BlueBubble(startPosition: newPos)) },
                ]))
        }
        
        super.reflectedHit()
    }
}

/**
 * Reach Finder: game over
 * Direct Hit: bubble removed
 * Reflected Hit: clear reds
 */
public class RedBubble: Bubble {
    
    private let cbSymbolText = "X"//×"
    private let lifetime: TimeInterval = 6.0
    
    public init() {
        super.init(
            from: GameArea.randomSpawnPoint(),
            to: GameArea.finderPosition,
            cbSymbol: self.cbSymbolText,
            lifetime: self.lifetime
        )
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.bubbleRed
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
        
        self.material.diffuse.contents = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 0.5)
        self.shatterEffect.particleColor = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 1)
        
        self.runAction(.wait(duration: self.lifetime)) {
            GameArea.gameOver()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func reflectedHit() {
        guard let instance = GameArea.instance else { return }
        
        var closestDistance = Float.infinity
        var closestBubble: Bubble?
        
        for child in instance.childNodes {
            guard let bubble = child as? Bubble, bubble !== self else { continue }
            let distance = abs(bubble.presentation.worldPosition - self.presentation.worldPosition)
            
            if distance < closestDistance {
                closestDistance = distance
                closestBubble = bubble
            }
        }
        
        let reflected: Bullet
        if let targetBubble = closestBubble {
            reflected = Bullet(
                position: self.presentation.position,
                direction: targetBubble.presentation.position
            )
        } else {
            reflected = Bullet(
                position: self.presentation.position,
                direction: self.presentation.position + SCNVector3(0, 1, 0)
            )
        }
        
        reflected.setReflect(to: true)
        instance.addChildNode(reflected)
        
        super.reflectedHit()
    }
}

/**
 * Reach Finder: no effect
 * Direct Hit: super powerup
 * Reflected Hit: super powerup, double duration
 */
public class GreenBubble: Bubble {
    
    private let cbSymbolText = "★"
    private let lifetime: TimeInterval = 4.0
    
    public init() {
        super.init(
            from: GameArea.randomSpawnPoint(),
            to: GameArea.randomSpawnPoint(),
            cbSymbol: self.cbSymbolText,
            lifetime: self.lifetime
        )
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.bubbleGreen
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
        
        self.material.diffuse.contents = #colorLiteral(red: 0, green: 0.6588235294, blue: 0, alpha: 0.5)
        self.shatterEffect.particleColor = #colorLiteral(red: 0, green: 0.6588235294, blue: 0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func directHit() {
        self.parent?.addChildNode(Powerup(at: self.position, isReflected: false))
        super.directHit()
    }
    
    public override func reflectedHit() {
        self.parent?.addChildNode(Powerup(at: SCNVector3Zero, isReflected: true))
        super.reflectedHit()
    }
    
    public override func destroy() {
        super.destroy()
        
        self.shatterEffect.birthRate = 980
        
        self.shatterEffect.particleLifeSpan = 1.0
        self.shatterEffect.particleLifeSpanVariation = 0.6
        
        self.shatterEffect.particleVelocity = 0.6
        self.shatterEffect.particleVelocityVariation = 0.6
    }
}

/**
 * Reach Finder: no effect
 * Direct Hit: game over
 * Reflected Hit: bubble removed, spawn a blue
 */
public class YellowBubble: Bubble {
    
    private let cbSymbolText = "❗️"
    private let lifetime: TimeInterval = 8.0
    
    public init() {
        super.init(
            from: GameArea.randomSpawnPoint(),
            to: GameArea.randomSpawnPoint(),
            cbSymbol: self.cbSymbolText,
            lifetime: self.lifetime
        )
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.bubbleGreen
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
        
        self.material.diffuse.contents = #colorLiteral(red: 0.9176470588, green: 0.7529411765, blue: 0, alpha: 0.5)
        self.shatterEffect.particleColor = #colorLiteral(red: 0.9176470588, green: 0.7529411765, blue: 0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func directHit() {
        super.directHit()
        GameArea.gameOver()
        
        let sizeAnimation = CABasicAnimation()
        sizeAnimation.fromValue = 1.0
        sizeAnimation.toValue = 12.0
        
        self.shatterEffect.particleLifeSpan = 1.2
        self.shatterEffect.particleLifeSpanVariation = 0.6
        
        self.shatterEffect.particleVelocity = 0.8
        self.shatterEffect.particleVelocityVariation = 0.8
        
        self.shatterEffect.propertyControllers = [
            .size: SCNParticlePropertyController(animation: sizeAnimation),
        ]
    }
    
    public override func reflectedHit() {
        guard let parentNode = self.parent else { fatalError("Orphan") }
        
        super.reflectedHit()
        parentNode.addChildNode(BlueBubble(startPosition: self.position))
    }
}
