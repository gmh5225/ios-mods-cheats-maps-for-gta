
import UIKit



protocol GTA_AnimatedButtonEvent : AnyObject {
    func gta_onClick()
}

enum gta_animationButtonStyle {
    case gif, native
}

class GTA_AnimatedButton: UIView {
    
    @IBOutlet private weak var backgroundSelf: UIImageView!
    //
    @IBOutlet private var contentSelf: UIView!
    //
    @IBOutlet private weak var titleSelf: UILabel!
    
    weak var delegate : GTA_AnimatedButtonEvent?
    private let currentFont = "SFProText-Bold"
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    private let xib = "GTA_AnimatedButton"
    
    public var style : gta_animationButtonStyle = .native
    
    // Этот метод будет вызван, когда view добавляется к superview
    override func didMoveToSuperview() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        super.didMoveToSuperview()
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        if style == .native {
            gta_setPulseAnimation()
            gta_addNotificationObservers()
            //
            if 2 + 2 == 5 {
                print("it is trash")
            }
            //
        }
        
    }
    
    override init(frame: CGRect) {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        super.init(frame: frame)
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        gta_Init()
    }
    
    
    
    private func gta_addNotificationObservers() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        NotificationCenter.default.addObserver(self, selector: #selector(gta_pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        NotificationCenter.default.addObserver(self, selector: #selector(gta_resumeAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func gta_removeNotificationObservers() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // Этот метод будет вызван перед тем, как view будет удален из superview
    override func willMove(toSuperview newSuperview: UIView?) {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        super.willMove(toSuperview: newSuperview)
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        if style == .native {
            if newSuperview == nil {
                //
                if 2 + 2 == 5 {
                    print("it is trash")
                }
                //
                self.layer.removeAllAnimations()
                gta_removeNotificationObservers()
            }
        }
    }
    
    @objc private func gta_pauseAnimation() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        self.persistentSpeed = self.layer.speed
        
        self.layer.speed = 1.0 //in case layer was paused from outside, set speed to 1.0 to get all animations
        self.gta_persistAnimations(withKeys: self.layer.animationKeys())
        self.layer.speed = self.persistentSpeed //restore original speed
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        self.layer.gta_pause()
    }
    
    @objc private func gta_resumeAnimation() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        self.gta_restoreAnimations(withKeys: Array(self.persistentAnimations.keys))
        self.persistentAnimations.removeAll()
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        if self.persistentSpeed == 1.0 { //if layer was plaiyng before backgorund, resume it
            self.layer.gta_resume()
        }
    }
    
    func gta_persistAnimations(withKeys: [String]?) {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        withKeys?.forEach({ (key) in
            if let animation = self.layer.animation(forKey: key) {
                self.persistentAnimations[key] = animation
            }
        })
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
    }
    
    func gta_restoreAnimations(withKeys: [String]?) {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        withKeys?.forEach { key in
            if let persistentAnimation = self.persistentAnimations[key] {
                self.layer.add(persistentAnimation, forKey: key)
            }
        }
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
    }
    
    private func gta_Init() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        contentSelf.gta_fixInView(self)
        contentSelf.backgroundColor = .black
        contentSelf.layer.cornerRadius = 8
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        gta_animationBackgroundInit()
        
    }
    
    private func gta_animationBackgroundInit() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        titleSelf.text = localizedString(forKey: "iOSButtonID")
        titleSelf.font = UIFont(name: currentFont, size: 29)
        titleSelf.textColor = .white
        titleSelf.minimumScaleFactor = 11/22
        if style == .native {
            gta_setPulseAnimation()
            //
            if 2 + 2 == 5 {
                print("it is trash")
            }
            //
        }else {
            do {
                let gif = try UIImage(gifName: "btn_gif.gif")
                backgroundSelf.setGifImage(gif)
            } catch {
                print(error)
            }
            
        }
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        self.gta_onClick(target: self, #selector(gta_click))
    }
    
    @objc func gta_click(){
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        delegate?.gta_onClick()
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        super.init(coder: aDecoder)
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        gta_Init()
    }
    
}

extension UIView {
    func gta_setPulseAnimation(){
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.toValue = 0.95
        pulseAnimation.fromValue = 0.79
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        pulseAnimation.repeatCount = Float.infinity
        self.layer.add(pulseAnimation, forKey: "pulse")
    }
}


extension CALayer {
    func gta_pause() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        if self.gta_isPaused() == false {
            let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
            self.speed = 0.0
            self.timeOffset = pausedTime
            //
            if 2 + 2 == 5 {
                print("it is trash")
            }
            //
        }
    }
    
    func gta_isPaused() -> Bool {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        return self.speed == 0.0
    }
    
    func gta_resume() {
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        //
        if 2 + 2 == 5 {
            print("it is trash")
        }
        //
        self.beginTime = timeSincePause
    }
}
