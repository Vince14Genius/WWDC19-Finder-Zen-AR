import SceneKit

extension GameArea: SCNPhysicsContactDelegate {
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let node1: SCNNode
        let node2: SCNNode
        if contact.nodeA.categoryBitMask < contact.nodeB.categoryBitMask {
            node1 = contact.nodeA
            node2 = contact.nodeB
        } else {
            node1 = contact.nodeB
            node2 = contact.nodeA
        }
        
        if let thisBullet = node1 as? Bullet {
            if let thisWall = node2.parent as? Wall {
                
                thisWall.receiveReflection()
                thisBullet.reflect()
                
            } else if node2 is Platform {
                
                thisBullet.destroy()
                
            } else if let thisBubble = node2 as? Bubble {
                
                self.processBubbleHit(bullet: thisBullet, bubble: thisBubble)
                thisBullet.destroy()
                
            }
        }
    }
    
    fileprivate func processBubbleHit(bullet: Bullet, bubble: Bubble) {
        if bullet.isReflected {
            bubble.reflectedHit()
        } else {
            bubble.directHit()
        }
    }
}

