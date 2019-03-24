import UIKit

public class TitleView: UIView, ViewInitializable {
    let imageTitle = UIImageView(image: #imageLiteral(resourceName: "title-hero.png"))
    let buttonPlay = UIButton()
    
    public func initialize() {
        self.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background@2x.jpg"))
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImage)
        
        let topHalf = UIView()
        let bottomHalf = UIView()
        
        self.addSubview(topHalf)
        self.addSubview(bottomHalf)
        
        topHalf.addSubview(self.imageTitle)
        bottomHalf.addSubview(self.buttonPlay)
        
        topHalf.translatesAutoresizingMaskIntoConstraints = false
        bottomHalf.translatesAutoresizingMaskIntoConstraints = false
        self.imageTitle.translatesAutoresizingMaskIntoConstraints = false
        self.buttonPlay.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        equalConstraint(self.imageTitle.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.imageTitle.centerYAnchor, topHalf.centerYAnchor)
        
        equalConstraint(self.buttonPlay.centerXAnchor, self.centerXAnchor)
        equalConstraint(self.buttonPlay.centerYAnchor, bottomHalf.centerYAnchor)
        
        equalConstraint(backgroundImage.centerXAnchor, self.centerXAnchor)
        equalConstraint(backgroundImage.centerYAnchor, self.centerYAnchor)
        
        // Add size constraints
        
        self.imageTitle.widthAnchor.constraint(equalToConstant: 480).isActive = true
        self.imageTitle.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        equalConstraint(backgroundImage.widthAnchor, backgroundImage.heightAnchor)
        backgroundImage.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor).isActive = true
        
        // Set up button
        
        self.buttonPlay.setTitle("     ▶︎    ", for: .normal)
        self.buttonPlay.setTitleColor(.black, for: .normal)
        self.buttonPlay.titleLabel?.font = .systemFont(ofSize: 64)
        
        self.buttonPlay.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.buttonPlay.layer.cornerRadius = 28
        
        self.buttonPlay.addTarget(
            self,
            action: #selector(self.actionPlay),
            for: .primaryActionTriggered
        )
        
        // Button animation
        
        func animate(keyPath: String) {
            let altAnimation = CAKeyframeAnimation(keyPath: keyPath)
            altAnimation.duration = 1.0
            altAnimation.repeatCount = .greatestFiniteMagnitude
            
            altAnimation.values = []
            for i in 1...20 {
                altAnimation.values?.append(1 + 0.05 * sin(.pi * 2 * 0.05 * Double(i)))
            }
            
            self.buttonPlay.layer.add(altAnimation, forKey: nil)
        }
        
        animate(keyPath: "transform.scale.x")
        animate(keyPath: "transform.scale.y")
    }
    
    @objc func actionPlay() {
        TransitionController.instance.showContentView()
    }
}
