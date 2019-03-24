import SceneKit

fileprivate let sideLength: CGFloat = 0.15

public class Finder: SCNNode {
    
    public static let yPosition: Float = 0.075
    
    private let box = SCNBox(
        width: sideLength,
        height: sideLength,
        length: sideLength,
        chamferRadius: 0.012
    )
    
    public override init() {
        
        super.init()
        
        let innerNode = SCNNode(geometry: self.box)
        self.addChildNode(innerNode)
        innerNode.eulerAngles.y = -.pi / 2
        
        self.position.y = Finder.yPosition
        
        let lightNode = SCNNode()
        lightNode.position.y = Float(sideLength)
        self.addChildNode(lightNode)
        
        lightNode.letThereBeLight(type: .omni, intensity: 200)
        
        // Set up material
        
        let materialXPos = SCNMaterial()
        materialXPos.diffuse.contents = #imageLiteral(resourceName: "finder-x-pos.png")
        
        let materialXNeg = SCNMaterial()
        materialXNeg.diffuse.contents = #imageLiteral(resourceName: "finder-x-neg.png")
        
        let materialYPos = SCNMaterial()
        materialYPos.diffuse.contents = #imageLiteral(resourceName: "finder-y-pos.png")
        
        let materialYNeg = SCNMaterial()
        materialYNeg.diffuse.contents = #imageLiteral(resourceName: "finder-y-neg.png")
        
        let materialZPos = SCNMaterial()
        materialZPos.diffuse.contents = #imageLiteral(resourceName: "finder-z-pos.png")
        
        let materialZNeg = SCNMaterial()
        materialZNeg.diffuse.contents = #imageLiteral(resourceName: "finder-z-neg.png")
        
        self.box.materials = [
            materialZNeg,
            materialXNeg,
            materialZPos,
            materialXPos,
            materialYPos,
            materialYNeg,
        ]
        
        // Setup physics body
        
        self.physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: self.box, options: nil)
        )
        
        self.physicsBody?.categoryBitMask = CategoryBitMasks.finder
        self.physicsBody?.continuousCollisionDetectionThreshold = sideLength / 2
        
        // Breathing animation
        
        self.runAction(Actions.breathingAnimation)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
