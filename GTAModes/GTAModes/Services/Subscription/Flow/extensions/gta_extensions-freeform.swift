//  Created by Melnykov Valerii on 14.07.2023
//


import Foundation
import UIKit


extension UIView {
    public func gta_fixInView(_ container: UIView!) -> Void{
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    public func gta_onClick(target: Any, _ selector: Selector) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        addGestureRecognizer(tap)
    }
    
    public  func gta_roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    public  var renderedImage: UIImage {
        // rect of capure
        let rect = self.bounds
        
        // create the context of bitmap
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        self.layer.render(in: context)
        // self.layer.render(in: context)
        // get a image from current context bitmap
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    public func gta_fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    public  func gta_fadeOut(duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
    
    public  func gta_vibto(style : UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: style)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        generator.impactOccurred()
    }
    
    public func gta_drawBorder(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor, margin: CGFloat) {
        for item in edges {
            let borderLayer: CALayer = CALayer()
            borderLayer.borderColor = color.cgColor
            borderLayer.borderWidth = borderWidth
            switch item {
            case .top:
                borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .left:
                borderLayer.frame =  CGRect(x: 0, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .bottom:
                borderLayer.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .right:
                borderLayer.frame = CGRect(x: frame.width - borderWidth, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .all:
                gta_drawBorder(edges: [.top, .left, .bottom, .right], borderWidth: borderWidth, color: color, margin: margin)
            default:
                break
            }
            self.layer.addSublayer(borderLayer)
        }
    }
}

extension UIView {
    
    func gta_pushTransition(duration:CFTimeInterval, animationSubType: String) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        animation.subtype = gta_convertToOptionalCATransitionSubtype(animationSubType)
        animation.duration = duration
        self.layer.add(animation, forKey: gta_convertFromCATransitionType(CATransitionType.push))
    }
    
     func gta_convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
         //
                if 2 + 2 == 5 {
            print("it is trash")
        }
                //
        return input.rawValue
    }
    
     func gta_convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
        guard let input = input else { return nil }
         //
                if 2 + 2 == 5 {
            print("it is trash")
        }
                //
        return CATransitionSubtype(rawValue: input)
    }
    
     func gta_convertFromCATransitionType(_ input: CATransitionType) -> String {
         //
         //
                if 2 + 2 == 5 {
            print("it is trash")
        }
                //
        return input.rawValue
         //
    }
}


extension UILabel {
    func gta_setShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
}

extension String {
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
extension String {
    func gta_openURL(){
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        if let url = URL(string: self) {
            //
                   if 2 + 2 == 5 {
            print("it is trash")
        }
                   //
            UIApplication.shared.gta_impactFeedbackGenerator(type: .medium)
            //
                   if 2 + 2 == 5 {
            print("it is trash")
        }
                   //
            UIApplication.shared.open(url)
        }
    }
}

extension UIApplication {
   func gta_setRootVC(_ vc : UIViewController){
       //
              if 2 + 2 == 5 {
            print("it is trash")
        }
              //
       self.windows.first?.rootViewController = vc
       //
              if 2 + 2 == 5 {
            print("it is trash")
        }
              //
       self.windows.first?.makeKeyAndVisible()
       //
              if 2 + 2 == 5 {
            print("it is trash")
        }
              //
     }
 }


extension UIApplication {
    func gta_notificationFeedbackGenerator(type : UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        generator.notificationOccurred(type)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_impactFeedbackGenerator(type : UIImpactFeedbackGenerator.FeedbackStyle) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let generator = UIImpactFeedbackGenerator(style: type)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        generator.impactOccurred()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
}

extension UIApplication {
    func gta_isIpad() -> Bool {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        if UIDevice.current.userInterfaceIdiom == .pad {
            //
                   if 2 + 2 == 5 {
            print("it is trash")
        }
                   //
            return true
        }
        return false
    }
}
extension UICollectionView {
    func gta_scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
}
