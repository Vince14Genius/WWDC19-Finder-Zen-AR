import ARKit

extension FZView: ARSCNViewDelegate {
    
    public static var platformYBase: SCNNode?
    
    private func checkAnchor(node: SCNNode) {
        
        func relativeDistance(of inputNode: SCNNode) -> Float {
            let relativePos = inputNode.convertPosition(SCNVector3Zero, to: self.gameArea)
            return abs(relativePos.x, relativePos.z)
        }
        
        let nodeDistance = relativeDistance(of: node)
        
        if let oldBase = FZView.platformYBase {
            
            // Set platformYBase to whichever node that is closer
            
            let oldBaseDistance = relativeDistance(of: oldBase)
            
            if nodeDistance < oldBaseDistance {
                FZView.platformYBase = node
            }
            
        } else {
            FZView.platformYBase = node
        }
    }
    
    private func setupGeometry(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        let planeGeometry = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!)!
        planeGeometry.update(from: planeAnchor.geometry)
        
        node.geometry = planeGeometry
        
        let material = SCNMaterial()
        material.diffuse.contents = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        material.isDoubleSided = true
        planeGeometry.materials = [material]
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return nil }
        let node = SCNNode()
        self.setupGeometry(node: node, planeAnchor: planeAnchor)
        
        return node
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        if planeAnchor.alignment == .horizontal { checkAnchor(node: node) }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        if planeAnchor.alignment == .horizontal { checkAnchor(node: node) }
        if let planeGeometry = node.geometry as? ARSCNPlaneGeometry {
            planeGeometry.update(from: planeAnchor.geometry)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        if node === FZView.platformYBase {
            FZView.platformYBase = nil
        }
    }
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        self.labelARStatus.isHidden = false
        switch camera.trackingState {
        case .limited(.excessiveMotion): self.labelARStatus.text = "AR Tracking Limited\nPlease don't move so quickly."
        case .limited(.initializing): self.labelARStatus.text = "Initializing AR Tracking..."
        case .limited(.insufficientFeatures): self.labelARStatus.text = "AR Tracking Limited\nEither not enough light, surface too reflective, or not enough texture"
        case .limited(.relocalizing): self.labelARStatus.text = "Relocalizing..."
        case .normal: self.labelARStatus.isHidden = true
        case .notAvailable: self.labelARStatus.text = "AR Tracking Not Available"
        }
    }
    
    public func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return false
    }
}

