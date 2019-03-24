import SceneKit

public class GameArea: SCNNode {
    
    // Static values
    
    public static let spawnRadiusMinimum: Float = 1.0
    public static let spawnRadiusMaximum: Float = 1.1
    
    public static let wallRadius: Float = 0.5
    
    public static var finderPosition: SCNVector3 {
        return SCNVector3(0, Finder.yPosition, 0)
    }
    
    public static var instance: GameArea? { return GameArea.instanceInternal }
    private static var instanceInternal: GameArea?
    
    public static func addScore(by addition: Int) {
        guard let instance = GameArea.instance else {
            fatalError("GameArea instance not found at addScore(_:)")
        }
        
        instance.runAction(.repeat(.sequence([
            .run { _ in
                instance.score += 1
                instance.finder.runAction(.sequence([
                    .scale(by: 1.1, duration: 0.2),
                    .scale(by: CGFloat(1) / 1.1, duration: 0.2),
                    ]))
            },
            .wait(duration: 0.3),
            ]), count: addition))
    }
    
    public static func gameOver() {
        guard let instance = GameArea.instance, !instance.isGameOver else { return }
        instance.isGameOver = true
        
        let animationDuration = 1.0
        
        func animate(keyPath: String, from fromValue: Any, to toValue: Any) {
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = animationDuration
            
            instance.view?.darkOverlay.layer.add(animation, forKey: nil)
        }
        
        instance.view?.darkOverlay.layer.opacity = 1.0
        animate(keyPath: "opacity", from: 0.0, to: 1.0)
        
        instance.runAction(.wait(duration: animationDuration)) {
            for child in instance.childNodes {
                child.removeFromParentNode()
            }
            TransitionController.instance.showGameoverScreen(finalScore: instance.score)
        }
    }
    
    // MARK: - Nodes and references
    
    private let platform = Platform()
    public let holoStand = HoloStand()
    
    public let finder = Finder()
    
    public weak var view: FZView?
    
    private let baseLevelWalls = SCNNode()
    
    // MARK: - Constants
    
    private let baseLevelWallCount = 8
    
    // MARK: - Instance properties
    
    public var score = 0 {
        didSet { self.view?.updateScoreLabel(to: score) }
    }
    
    private var isGameOver = false
    
    // MARK: - Instance methods
    
    public init(in fzView: FZView) {
        self.view = fzView
        super.init()
        GameArea.instanceInternal = self
        
        self.addChildNode(self.platform)
        self.addChildNode(self.holoStand)
        
        // Set up Finder
        
        self.addChildNode(self.finder)
        
        self.finder.runAction(.repeatForever(.sequence([
            .run { _ in
                guard let pov = self.view?.pointOfView else { return }
                
                let angle = getYAngle(
                    from: self.finder.worldPosition,
                    to: pov.worldPosition
                )
                
                let delta = abs(angle - (self.finder.eulerAngles.y))
                
                //if (delta > .pi / 3) && (delta < 5 * .pi / 3) {
                    self.finder.runAction(.rotateTo(
                        x: 0,
                        y: CGFloat(angle),
                        z: 0,
                        duration: 0.6,
                        usesShortestUnitArc: true
                        ))
                    self.finder.runAction(Actions.finderJump)
                //}
            },
            .wait(duration: 2.0  /*0.6*/),
            ])))
        
        // Main spawn loop
        
        self.runAction(self.getSpawnLoop())
        
        /* Test Loop
        self.runAction(.repeatForever(.sequence([
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(RedBubble())
                self.addChildNode(BlueBubble())
                self.addChildNode(GreenBubble())
                self.addChildNode(YellowBubble())
            },
            ])))
        */
        
        // Set up walls
        
        self.addChildNode(self.baseLevelWalls)
        
        func createWall(y: Float, radius: Float, index: Int, totalCount: Int) -> Wall {
            let wall = Wall()
            wall.position.y = y
            
            let angle = Float(index) / Float(totalCount) * 2 * .pi
            wall.position.x = radius * cos(angle)
            wall.position.z = radius * sin(angle)
            
            return wall
        }
        
        for i in 1...self.baseLevelWallCount {
            self.baseLevelWalls.addChildNode(
                createWall(
                    y: self.finder.position.y + GameArea.spawnRadiusMaximum / 2,
                    radius: GameArea.wallRadius,
                    index: i,
                    totalCount: self.baseLevelWallCount
                )
            )
        }
        
        self.baseLevelWalls.runAction(.repeatForever(
            .rotateBy(x: 0, y: .pi, z: 0, duration: 32)
            ))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isShootingAvailable = true
    
    public func playerFire() {
        guard self.isShootingAvailable, let fzView = self.view, let pov = fzView.pointOfView else { return }
        self.isShootingAvailable = false
        
        let rootNode = fzView.scene.rootNode
        
        let spawnPoint = pov.convertPosition(Bullet.relativeSpawnPoint, to: self)
        let direction = rootNode.convertPosition(fzView.vrnWorldPosition, to: self) - rootNode.convertPosition(pov.position, to: self)
        
        let bullet = Bullet(position: spawnPoint, direction: direction)
        self.addChildNode(bullet)
        
        self.runAction(.wait(duration: 0.2)) { self.isShootingAvailable = true }
    }
    
    // MARK: - Game Spawn Loop
    
    private var difficulty = 1
    
    public func getSpawnLoop() -> SCNAction {
        return SCNAction.sequence([
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(RedBubble())
                self.view?.showTutorial(
                    text: "DESTROY the Red (×) bubble, to protect Finder.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(BlueBubble())
                self.view?.showTutorial(
                    text: "Let the Blue (○) bubble PASS THROUGH, for a point.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                for _ in 1...8 { self.addChildNode(YellowBubble()) }
                self.view?.showTutorial(
                    text: "Let the Yellow (!) bubbles PASS THROUGH, to protect Finder.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(GreenBubble())
                self.view?.showTutorial(
                    text: "DESTROY the rare Green (★) bubble, for a powerup.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(BlueBubble())
                for _ in 1...16 { self.addChildNode(YellowBubble()) }
                self.view?.showTutorial(
                    text: "Aim for the floating portals to summon Modified bullets.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                self.addChildNode(BlueBubble())
                self.addChildNode(RedBubble())
                self.addChildNode(GreenBubble())
                for _ in 1...4 { self.addChildNode(YellowBubble()) }
                self.view?.showTutorial(
                    text: "Modified bullets trigger GOOD alternative effects on bubbles.",
                    duration: 4.0
                )
            },
            .wait(duration: 4.0),
            .run { _ in
                self.view?.showTutorial(
                    text: "That's all! Use what you've learned to play on.",
                    duration: 4.0
                )
            },
            .repeatForever(.sequence([
                .wait(duration: 4.0),
                .run { _ in
                    self.view?.hideTutorial()
                    
                    let modifier = sqrt(Double(self.difficulty))
                    
                    self.difficulty += 1
                    
                    self.addChildNode(BlueBubble())
                    self.addChildNode(RedBubble())
                    
                    if Int.random(in: 1...100) <= Int(modifier) {
                        self.addChildNode(RedBubble())
                    }
                    
                    if Int.random(in: 101...200) <= Int(modifier) {
                        self.addChildNode(RedBubble())
                    }
                    
                    if Int.random(in: 201...300) <= Int(modifier) {
                        self.addChildNode(RedBubble())
                    }
                    
                    if Int.random(in: 1...100) <= 25 { self.addChildNode(GreenBubble()) }
                    if Int.random(in: 1...100) <= 25 { self.addChildNode(GreenBubble()) }
                    for _ in 1...Int.random(in: 2...8) { self.addChildNode(YellowBubble()) }
                }
                ]))
            ])
    }
}
