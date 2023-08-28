//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

class GTA_ReusableCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gta_setupCell()
    }
    
    func gta_setupCell() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 1)
        cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        cellLabel.font = UIFont(name: GTA_Configurations.fontName, size: 10)
        imageLabel.font = UIFont(name: GTA_Configurations.fontName, size: 10)
        contentContainer.layer.cornerRadius = 8
        titleContainer.layer.cornerRadius = 8
        imageLabel.gta_setShadow(with: 0.5)
        cellLabel.gta_setShadow(with: 0.5)
        cellImage.layer.cornerRadius = 8
//        cellImage.layer.borderColor = UIColor.black.cgColor
//        cellImage.layer.borderWidth = 2
    }
}
