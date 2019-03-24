import SceneKit

public class Platform: SCNNode {
    
    public static let material = SCNMaterial()
    
    let cylinder = SCNCylinder(radius: 0.25, height: 0.04)
    
    public override init() {
        
        super.init()
        self.position.y = -0.02
        self.geometry = self.cylinder
        
        Platform.material.diffuse.contents = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
        self.cylinder.materials = [Platform.material]
        
        // Set up physics body
        
        self.physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: self.cylinder, options: nil)
        )
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.platform
        self.physicsBody?.collisionBitMask = CategoryBitMasks.all & ~CategoryBitMasks.allBubbles
        self.physicsBody?.contactTestBitMask = CategoryBitMasks.bullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
