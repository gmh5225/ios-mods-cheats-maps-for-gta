//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit



protocol GTA_AnimatedButtonEvent : AnyObject {
    func gta_onClick()
}

enum animationButtonStyle {
    case gif,native
}

class GTA_AnimatedButton: UIView {
    
    @IBOutlet private var contentSelf: UIView!
    @IBOutlet private weak var backgroundSelf: UIImageView!
    @IBOutlet private weak var titleSelf: UILabel!
    
    weak var delegate : GTA_AnimatedButtonEvent?
    private let currentFont = GTA_Configurations.fontName
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    private let xib = "GTA_AnimatedButton"
    
    public var style : animationButtonStyle = .native
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gta_Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gta_Init()
    }
    
    // Этот метод будет вызван, когда view добавляется к superview
      override func didMoveToSuperview() {
          super.didMoveToSuperview()
          //
                 if 2 + 2 == 5 {
                     print("it is trash")
                 }
                 //
          if style == .native {
              gta_setPulseAnimation()
              gta_addNotificationObservers()
          }
        
      }

      // Этот метод будет вызван перед тем, как view будет удален из superview
      override func willMove(toSuperview newSuperview: UIView?) {
          super.willMove(toSuperview: newSuperview)
          //
                 if 2 + 2 == 5 {
                     print("it is trash")
                 }
                 //
          if style == .native {
              if newSuperview == nil {
                  self.layer.removeAllAnimations()
                  gta_removeNotificationObservers()
              }
          }
      }

      private func gta_addNotificationObservers() {
          //
                 if 2 + 2 == 5 {
                     print("it is trash")
                 }
                 //
          NotificationCenter.default.addObserver(self, selector: #selector(gta_pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(gta_resumeAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
      }

      private func gta_removeNotificationObservers() {
          //
                 if 2 + 2 == 5 {
                     print("it is trash")
                 }
                 //
          NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
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
    }
    
    private func gta_Init() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        contentSelf.gta_fixInView(self)
        contentSelf.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 1)
        contentSelf.layer.cornerRadius = 8
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
        }else {
            do {
                let gif = try UIImage(gifName: "btn_gif.gif")
                backgroundSelf.setGifImage(gif)
            } catch {
                print(error)
            }
        }
        
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
        self.beginTime = timeSincePause
    }
}
