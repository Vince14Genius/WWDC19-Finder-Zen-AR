import SceneKit

public class Powerup: SCNNode {
    
    public static let material = SCNMaterial()
    
    let sphere = SCNSphere(radius: 0.01)
    
    public init(at location: SCNVector3, isReflected: Bool) {
        
        super.init()
        self.geometry = self.sphere
        self.position = location
        self.sphere.materials = [Powerup.material]
        Powerup.material.blendMode = .alpha
        Powerup.material.isDoubleSided = true
        
        // Business logic
        
        let duration: TimeInterval
        if isReflected {
            Powerup.material.diffuse.contents = #colorLiteral(red: 0.3411764706, green: 0.06569102113, blue: 0.7454335387, alpha: 0.499587368)
            GameArea.addScore(by: 20)
            duration = 6.0
        } else {
            Powerup.material.diffuse.contents = #colorLiteral(red: 0.03053477113, green: 1, blue: 0.6075319102, alpha: 0.4976892606)
            GameArea.addScore(by: 10)
            duration = 3.0
        }
        
        // Main loop
        
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 0.1),
            .run { _ in
                guard let parentNode = self.parent else { return }
                
                for child in parentNode.childNodes {
                    guard let bubble = child as? Bubble else { continue }
                    
                    if bubble is RedBubble || bubble is YellowBubble {
                        let distance = abs(bubble.worldPosition - self.worldPosition)
                        
                        if distance <= Float(self.sphere.radius) * abs(self.scale) {
                            bubble.destroy()
                        }
                    }
                }
            },
            ])))
        
        self.runAction(.sequence([
            .scale(to: CGFloat(GameArea.spawnRadiusMaximum) * 200, duration: duration)
            ])) {
            self.removeFromParentNode()
        }
        
        self.runAction(.fadeOpacity(to: 0.3, duration: duration))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
