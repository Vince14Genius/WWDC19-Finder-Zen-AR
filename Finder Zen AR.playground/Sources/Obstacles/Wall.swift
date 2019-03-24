import SceneKit

public class Wall: SCNNode {
    
    private let cylinder = SCNCylinder(radius: 0.1, height: 0.04)
    private let tube = SCNTube(innerRadius: 0.096, outerRadius: 0.098, height: 0.2)
    
    private let glowRing = SCNNode()
    private let glowRingMaterial = SCNMaterial()
    
    private let material = SCNMaterial()
    private let baseColor = #colorLiteral(red: 0.537254902, green: 0.2962147887, blue: 1, alpha: 0.2514304577)
    
    public override init() {
        super.init()
        self.position.y = -0.02
        
        //self.letThereBeLight(type: .omni, intensity: 200)
        
        // Set up innerNode
        
        let innerNode = SCNNode(geometry: self.cylinder)
        innerNode.eulerAngles.x = 0//.pi / 2
        self.addChildNode(innerNode)
        
        self.material.diffuse.contents = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.cylinder.materials = [material]
        
        // Set up glow ring
        
        self.glowRing.geometry = self.tube
        self.glowRingMaterial.blendMode = .add
        self.glowRingMaterial.diffuse.contents = self.baseColor
        self.tube.materials = [self.glowRingMaterial]
        
        innerNode.addChildNode(glowRing)
        
        // Set up physics body
        
        innerNode.physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: self.cylinder, options: nil)
        )
        
        innerNode.physicsBody?.categoryBitMask = CategoryBitMasks.wall
        innerNode.physicsBody?.collisionBitMask = 0
        innerNode.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
        
        // Reposition
        
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 0.1),
            .run { _ in
                self.tube.height = CGFloat(GameArea.spawnRadiusMaximum)
            },
            ])))
        
        /*
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 0.1),
            .run { _ in
                self.transform = self.presentation.transform
                
                let angle = getYAngle(
                    from: GameArea.finderPosition,
                    to: self.presentation.convertVector(
                        SCNVector3Zero,
                        from: GameArea.instance!
                    )
                ) - self.parent!.presentation.eulerAngles.y
                
                let rawRadius = abs(GameArea.povWorldPosition - GameArea.finderPosition) - 0.25
                
                let radius = (rawRadius > GameArea.wallRadius) ? rawRadius : GameArea.wallRadius
                
                self.runAction(.move(to: SCNVector3(
                    radius * cos(angle),
                    self.position.y,
                    radius * sin(angle)
                ), duration: 0.1))
            },
            ])))
        */
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func receiveReflection() {
        self.glowRing.runAction(.sequence([
            .run { _ in
                //self.glowRingMaterial.diffuse.contents = #colorLiteral(red: 0.9486960827, green: 0.737868618, blue: 0.2279654489, alpha: 0.5)
            },
            .scale(to: 1.2, duration: 0.4),
            .scale(to: 1.0, duration: 0.4),
            .run { _ in
                self.glowRingMaterial.diffuse.contents = self.baseColor
            },
            ]))
    }
}

extension GameArea {
    public static var povWorldPosition: SCNVector3? {
        return GameArea.instance?.view?.pointOfView?.position
    }
}
