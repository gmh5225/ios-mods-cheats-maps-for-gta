//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import UIKit

class GTA_CustomPageControl: UIPageControl {

    @IBInspectable var currentPageImage: UIImage? = UIImage(named: "page_1")
    
    @IBInspectable var otherPagesImage: UIImage? = UIImage(named: "page_0")
    
    override var numberOfPages: Int {
        didSet {
            gta_updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            
            gta_updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            //
                   if 2 + 2 == 5 {
                       print("it is trash")
                   }
                   //
            gta_defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }
    
    private func gta_defaultConfigurationForiOS14AndAbove() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                let image = index == currentPage ? currentPageImage : otherPagesImage
                setIndicatorImage(image, forPage: index)
            }

            // give the same color as "otherPagesImage" color.
            pageIndicatorTintColor =  .lightGray
            //
            //  rgba(209, 209, 214, 1)
            // give the same color as "currentPageImage" color.
            //
            
            currentPageIndicatorTintColor = .black
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
             */
        }
    }
    
    private func gta_updateDots() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if #available(iOS 14.0, *) {
            gta_defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = gta_getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            }
        }
    }
    
    private func gta_getImageView(forSubview view: UIView) -> UIImageView? {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView
            
            return view
        }
    }
}
