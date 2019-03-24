import UIKit

public class GameoverView: UIView, ViewInitializable {
    private let imageTitle = UIImageView(image: #imageLiteral(resourceName: "title-hero.png"))
    private let labelGameover = UILabel()
    private let buttonPlay = UIButton()
    private let buttonTitle = UIButton()
    private let labelFinalScore = UILabel()
    
    public var finalScore = 0 {
        didSet {
            self.labelFinalScore.text = "FINAL SCORE: \(self.finalScore)"
        }
    }
    
    public func initialize() {
        self.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
        
        let topHalf = UIView()
        let bottomHalf = UIView()
        
        self.addSubview(topHalf)
        self.addSubview(bottomHalf)
        self.addSubview(self.labelFinalScore)
        
        topHalf.addSubview(self.labelGameover)
        bottomHalf.addSubview(self.buttonPlay)
        bottomHalf.addSubview(self.buttonTitle)
        
        topHalf.translatesAutoresizingMaskIntoConstraints = false
        bottomHalf.translatesAutoresizingMaskIntoConstraints = false
        self.labelFinalScore.translatesAutoresizingMaskIntoConstraints = false
        self.labelGameover.translatesAutoresizingMaskIntoConstraints = false
        self.buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        self.buttonTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Add positional constraints
        
        func equalConstraint<T: AnyObject>(_ anchorA: NSLayoutAnchor<T>, _ anchorB: NSLayoutAnchor<T>) {
            anchorA.constraint(equalTo: anchorB).isActive = true
        }
        
        equalConstraint(topHalf.topAnchor, self.topAnchor)
        equalConstraint(topHalf.bottomAnchor, self.centerYAnchor)
        equalConstraint(bottomHalf.topAnchor, self.centerYAnchor)
        equalConstraint(bottomHalf.bottomAnchor, self.bottomAnchor)
        
        equalConstraint(topHalf.leadingAnchor, self.leadingAnchor)
        equalConstraint(topHalf.trailingAnchor, self.trailingAnchor)
        equalConstraint(bottomHalf.leadingAnchor, self.leadingAnchor)
        equalConstraint(bottomHalf.trailingAnchor, self.trailingAnchor)
        
        equalConstraint(self.labelFinalScore.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.labelFinalScore.centerYAnchor, self.centerYAnchor)
        
        equalConstraint(self.labelGameover.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.labelGameover.centerYAnchor, topHalf.centerYAnchor)
        
        equalConstraint(self.buttonPlay.centerXAnchor, self.centerXAnchor)
        self.buttonPlay.bottomAnchor.constraint(
            equalTo: bottomHalf.centerYAnchor,
            constant: -4
            ).isActive = true
        
        equalConstraint(self.buttonTitle.centerXAnchor, self.centerXAnchor)
        self.buttonTitle.topAnchor.constraint(
            equalTo: bottomHalf.centerYAnchor,
            constant: 4
            ).isActive = true
        
        // Add size constraints
        
        self.buttonPlay.widthAnchor.constraint(equalToConstant: 320).isActive = true
        self.buttonTitle.widthAnchor.constraint(equalToConstant: 320).isActive = true
        
        // Set up label
        
        self.labelGameover.text = "GAME OVER"
        self.labelGameover.textColor = #colorLiteral(red: 0.9254902005, green: 0.3644091109, blue: 0.2827629842, alpha: 1)
        self.labelGameover.font = .systemFont(ofSize: 72)
        
        self.labelFinalScore.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.labelFinalScore.font = .systemFont(ofSize: 36)
        
        // Set up buttons
        
        func setupButton(_ button: UIButton, title: String, background: UIColor) {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 36)
            
            button.backgroundColor = background
            button.layer.cornerRadius = 18
        }
        
        setupButton(self.buttonPlay, title: "PLAY AGAIN", background: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        
        self.buttonPlay.addTarget(
            self,
            action: #selector(self.actionPlay),
            for: .primaryActionTriggered
        )
        
        setupButton(self.buttonTitle, title: "MAIN MENU", background: #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1))
        
        self.buttonTitle.addTarget(
            self,
            action: #selector(self.actionTitle),
            for: .primaryActionTriggered
        )
    }
    
    @objc func actionPlay() {
        TransitionController.instance.showContentView()
    }
    
    @objc func actionTitle() {
        TransitionController.instance.showTitleScreen()
    }
}
