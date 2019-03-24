import SceneKit

public class HoloStand: SCNNode {
    
    private let numberOfSides = 12
    private let tube = SCNTube(innerRadius: 0.24, outerRadius: 0.24, height: 0.02)
    private let baseTube = SCNNode(geometry: SCNTube(innerRadius: 0.22, outerRadius: 0.26, height: 0.04))
    private let floatTube = SCNNode(geometry: SCNTube(innerRadius: 0.16, outerRadius: 0.20, height: 0.04))
    
    public override init() {
        super.init()
        
        self.tube.radialSegmentCount = self.numberOfSides
        self.geometry = self.tube
        self.addChildNode(self.baseTube)
        self.addChildNode(self.floatTube)
        
        self.floatTube.position.y = -0.15
        
        // Set up materials
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan
        material.blendMode = .add
        self.tube.materials = [material]
        self.floatTube.geometry?.materials = [material]
        
        self.baseTube.geometry?.materials = [Platform.material]
        
        // Run actions
        
        self.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 4)))
        
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 0.1),
            .run { _ in
                guard let parentNode = self.parent else {
                    self.removeAllActions()
                    return
                }
                
                if let yBase = FZView.platformYBase {
                    self.setHeight(to: parentNode.position.y - yBase.position.y)
                    self.baseTube.isHidden = false
                } else {
                    self.setHeight(to: 0.15)
                    self.baseTube.isHidden = true
                }
                
                self.floatTube.isHidden = !self.baseTube.isHidden
            },
            ])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setHeight(to height: Float) {
        guard height >= 0 else {
            self.setHeight(to: 0)
            return
        }
        
        self.tube.height = CGFloat(height)
        self.position.y = -height / 2 + 0.002
        
        self.baseTube.position.y = -height / 2
    }
}
