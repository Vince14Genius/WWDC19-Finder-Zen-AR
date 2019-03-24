import UIKit
import PlaygroundSupport
import ARKit

public protocol TransitionViewDelegate {
    func showContentView()
    func showTitleScreen()
    func showGameoverScreen(finalScore: Int)
}

public class TransitionController: TransitionViewDelegate {
    // Singleton
    public static let instance = TransitionController()
    
    public var arDebugOptions: ARSCNDebugOptions = []
    
    private init() {
        return
    }
    
    private func show(view: UIView & ViewInitializable) {
        PlaygroundPage.current.liveView = view
        view.initialize()
    }
    
    public func showContentView() {
        let fzView = FZView()
        self.show(view: fzView)
        fzView.debugOptions = arDebugOptions
    }
    
    public func showTitleScreen() {
        self.show(view: TitleView())
    }
    
    public func showGameoverScreen(finalScore: Int) {
        let gameoverView = GameoverView()
        self.show(view: gameoverView)
        gameoverView.finalScore = finalScore
    }
}

