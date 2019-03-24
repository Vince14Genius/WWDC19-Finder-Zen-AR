import ARKit

public class FZView: ARSCNView, ViewInitializable {
    
    // ViewReferenceNode properties
    
    private let viewReferencePoint = SCNVector3(0, 0, -1)
    private let viewReferenceNode = SCNNode()
    
    public var vrnWorldPosition: SCNVector3 {
        get {
            return self.viewReferenceNode.worldPosition
        }
    }
    
    // UI elements
    
    private let buttonPause = UIButton()
    private let buttonColorblindAid = UIButton()
    private let buttonReturn = UIButton()
    private let buttonFire = UIButton()
    
    private let labelColorblindAid = UILabel()
    private let labelReturn = UILabel()
    private let imageTargetCross = UIImageView(image: #imageLiteral(resourceName: "target-cross@3x.png"))
    
    private let labelScore = UILabel()
    private let labelTutorial = UILabel()
    public let labelARStatus = UILabel()
    
    // UI element collections
    
    private var menuPause = [UIView]()
    private var menuPlay = [UIView]()
    
    // MARK: - Instance properties
    
    public var gameArea: GameArea?
    
    private var didInitialize = false
    
    public var darkOverlay = UIView()
    
    // MARK: - Instance methods
    
    /// Set up the FZView
    /// - Important: Make sure that initialize() only runs once
    public func initialize() {
        
        guard !didInitialize else { return }
        didInitialize = true
        
        // Create GameArea
        
        self.gameArea = GameArea(in: self)
        
        // Add UI elements
        
        func addView(_ view: UIView) {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        func addLabel(_ label: UILabel) {
            label.textColor = .white
            label.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.layer.shadowRadius = 8
            label.layer.shadowOpacity = 0.5
            addView(label)
        }
        
        func addButton(_ button: UIButton, image: UIImage) {
            button.setImage(image, for: .normal)
            addView(button)
        }
        
        addView(self.imageTargetCross)
        addLabel(self.labelTutorial)
        
        addView(self.darkOverlay)
        
        addLabel(self.labelColorblindAid)
        addLabel(self.labelReturn)
        addLabel(self.labelARStatus)
        addLabel(self.labelScore)
        
        addButton(self.buttonFire, image: #imageLiteral(resourceName: "ui-fire@3x.png"))
        addButton(self.buttonColorblindAid, image: #imageLiteral(resourceName: "ui-colorblind-off@3x.png"))
        addButton(self.buttonPause, image: #imageLiteral(resourceName: "ui-pause@3x.png"))
        addButton(self.buttonReturn, image: #imageLiteral(resourceName: "ui-return@3x.png"))
        
        // Configure UI elements
        
        self.darkOverlay.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)  // Dark gray, not black
        self.darkOverlay.layer.opacity = 0
        
        self.labelReturn.text = "Return game to front of camera"
        self.updateCBIndicators()
        self.labelTutorial.isHidden = true
        self.labelTutorial.lineBreakMode = .byWordWrapping
        self.labelTutorial.numberOfLines = 0
        self.labelARStatus.numberOfLines = 0
        
        self.labelTutorial.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 1.8)
        self.labelScore.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 3.6)
        self.updateScoreLabel(to: 0)
        
        self.labelARStatus.isHidden = true
        
        func strongShadow(for view: UIView) {
            view.layer.shadowRadius = 16
            view.layer.shadowOpacity = 1.0
        }
        
        strongShadow(for: self.labelScore)
        strongShadow(for: self.labelTutorial)
        
        self.labelScore.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.labelScore.shadowOffset = CGSize.zero
        
        self.labelTutorial.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.labelTutorial.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.labelTutorial.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.menuPause = [self.buttonColorblindAid, self.labelColorblindAid]
        self.menuPlay = [self.buttonFire, self.imageTargetCross, self.buttonReturn, self.labelReturn]
        
        self.setHideMenu(self.menuPause, to: true)
        
        // Add positional constraints
        
        func equalConstraint<T: AnyObject>(_ anchorA: NSLayoutAnchor<T>, _ anchorB: NSLayoutAnchor<T>) {
            anchorA.constraint(equalTo: anchorB).isActive = true
        }
        
        equalConstraint(self.darkOverlay.topAnchor, self.topAnchor)
        equalConstraint(self.darkOverlay.bottomAnchor, self.bottomAnchor)
        equalConstraint(self.darkOverlay.leadingAnchor, self.leadingAnchor)
        equalConstraint(self.darkOverlay.trailingAnchor, self.trailingAnchor)
        
        equalConstraint(self.buttonFire.centerYAnchor, self.centerYAnchor)
        equalConstraint(self.buttonFire.trailingAnchor, self.trailingAnchor)
        
        equalConstraint(self.imageTargetCross.centerYAnchor, self.centerYAnchor)
        equalConstraint(self.imageTargetCross.centerXAnchor, self.centerXAnchor)
        
        equalConstraint(self.buttonPause.topAnchor, self.topAnchor)
        equalConstraint(self.buttonPause.leadingAnchor, self.leadingAnchor)
        
        equalConstraint(self.labelScore.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.labelScore.topAnchor, self.topAnchor)
        
        equalConstraint(self.labelARStatus.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.labelARStatus.topAnchor, self.labelScore.bottomAnchor)
        self.labelARStatus.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
        self.labelARStatus.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        
        self.labelTutorial.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
        self.labelTutorial.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        equalConstraint(self.labelTutorial.centerXAnchor, self.centerXAnchor)
        self.labelTutorial.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 66).isActive = true
        
        // Add side length constraints
        
        func sideLength(_ newValue: CGFloat, for button: UIButton) {
            button.widthAnchor.constraint(equalToConstant: newValue).isActive = true
            button.heightAnchor.constraint(equalToConstant: newValue).isActive = true
        }
        
        sideLength(56, for: self.buttonPause)
        sideLength(56, for: self.buttonColorblindAid)
        sideLength(56, for: self.buttonReturn)
        sideLength(112, for: self.buttonFire)
        
        self.buttonFire.contentEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16)
        
        // Constraints for bottom left buttons
        
        func bottomLeft(button: UIButton, label: UILabel) {
            equalConstraint(button.bottomAnchor, self.bottomAnchor)
            equalConstraint(button.leadingAnchor, self.leadingAnchor)
            
            equalConstraint(label.centerYAnchor, button.centerYAnchor)
            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 6).isActive = true
        }
        
        bottomLeft(button: self.buttonColorblindAid, label: self.labelColorblindAid)
        bottomLeft(button: self.buttonReturn, label: self.labelReturn)
        
        // Add button actions
        
        self.buttonFire.addTarget(self, action: #selector(self.actionFire), for: .primaryActionTriggered)
        self.buttonColorblindAid.addTarget(self, action: #selector(self.actionToggleColorblind), for: .primaryActionTriggered)
        self.buttonPause.addTarget(self, action: #selector(self.actionTogglePause), for: .primaryActionTriggered)
        self.buttonReturn.addTarget(self, action: #selector(self.actionReturn), for: .primaryActionTriggered)
        
        // Set up the AR session and world tracking
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        self.session.run(configuration, options: .resetTracking)
        
        self.delegate = self
        
        // Add necessary nodes
        
        if let ga = self.gameArea { self.scene.rootNode.addChildNode(ga) }
        self.pointOfView?.addChildNode(self.viewReferenceNode)
        self.viewReferenceNode.position = self.viewReferencePoint
    
        // Let there be Light
        
        let lightNode = SCNNode()
        self.pointOfView?.addChildNode(lightNode)
        lightNode.letThereBeLight(type: .omni, intensity: 1000)
        
        // Setup physics world
        
        self.scene.physicsWorld.contactDelegate = self.gameArea
        
        // Initialize platform position
        
        self.scene.rootNode.runAction(.repeat(.sequence([
            .run { _ in
                self.resetPosition()
            },
            .wait(duration: 0.1),
            ]), count: 20))
    }
    
    public func resetPosition() {
        self.gameArea?.position = vrnWorldPosition
        self.gameArea?.position.y -= 0.1
    }
    
    // MARK: - Reusable UI update methods
    
    public func setHideMenu(_ menu: [UIView], to isHidden: Bool) {
        for menuItem in menu {
            menuItem.isHidden = isHidden
        }
    }
    
    private func updateCBIndicators() {
        if isColorblindModeOn {
            self.buttonColorblindAid.setImage(#imageLiteral(resourceName: "ui-colorblind-on@3x.png"), for: .normal)
            self.labelColorblindAid.text = "COLORBLIND AID ON"
        } else {
            self.buttonColorblindAid.setImage(#imageLiteral(resourceName: "ui-colorblind-off@3x.png"), for: .normal)
            self.labelColorblindAid.text = "COLORBLIND AID OFF"
        }
    }
    
    public func updateScoreLabel(to newScore: Int) {
        self.labelScore.text = String(newScore)
        
        enum FadeType { case fadeIn, fadeOut }
        
        func animate(keyPath: String, from fromValue: Any, to toValue: Any, fadeType: FadeType) {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = 0.15
            
            switch fadeType {
            case .fadeIn: animation.fadeInDuration = 0.15
            case .fadeOut: animation.fadeOutDuration = 0.15
            }
            
            self.labelScore.layer.add(animation, forKey: nil)
        }
        
        animate(keyPath: "transform.scale.x", from: 1.0, to: 1.4, fadeType: .fadeOut)
        animate(keyPath: "transform.scale.y", from: 1.0, to: 1.4, fadeType: .fadeOut)
        
        (Timer(timeInterval: 0.1, repeats: false) { _ in
            animate(keyPath: "transform.scale.x", from: 1.4, to: 1.0, fadeType: .fadeIn)
            animate(keyPath: "transform.scale.y", from: 1.4, to: 1.0, fadeType: .fadeIn)
        }).fire()
    }
    
    public func showTutorial(text: String, duration: TimeInterval) {
        self.labelTutorial.text = text
        self.labelTutorial.isHidden = false
    }
    
    public func hideTutorial() {
        self.labelTutorial.isHidden = true
    }
    
    // MARK: - Button target selectors
    
    @objc private func actionFire() {
        self.gameArea?.playerFire()
    }
    
    @objc private func actionTogglePause() {
        self.scene.isPaused = !self.scene.isPaused
        
        if self.scene.isPaused {
            // Set button image to resume
            self.buttonPause.setImage(#imageLiteral(resourceName: "ui-resume@3x.png"), for: .normal)
        } else {
            // Set button image to pause
            self.buttonPause.setImage(#imageLiteral(resourceName: "ui-pause@3x.png"), for: .normal)
        }
        
        self.setHideMenu(self.menuPause, to: !self.scene.isPaused)
        self.setHideMenu(self.menuPlay, to: self.scene.isPaused)
    }
    
    @objc private func actionToggleColorblind() {
        isColorblindModeOn = !isColorblindModeOn
        self.updateCBIndicators()
    }
    
    @objc private func actionReturn() {
        self.resetPosition()
    }
}
