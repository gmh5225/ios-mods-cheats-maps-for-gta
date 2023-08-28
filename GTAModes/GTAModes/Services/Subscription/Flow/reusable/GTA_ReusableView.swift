//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

enum configView {
    case first,second,transaction
}

protocol ReusableViewEvent : AnyObject {
    func gta_nextStep(config: configView)
}

struct ReusableViewModel {
    var title : String
    var items : [ReusableContentCell]
}

struct ReusableContentCell {
    var title : String
    var image : UIImage
    var selectedImage: UIImage
}

class GTA_ReusableView: UIView, GTA_AnimatedButtonEvent {
    func gta_onClick() {
        self.protocolElement?.gta_nextStep(config: self.configView)
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var content: UICollectionView!
    @IBOutlet private weak var nextStepBtn: GTA_AnimatedButton!
    @IBOutlet private weak var titleWight: NSLayoutConstraint!
    @IBOutlet private weak var buttonBottom: NSLayoutConstraint!
    
    weak var protocolElement : ReusableViewEvent?
    
    public var configView : configView = .first
    public var viewModel : ReusableViewModel? = nil
    private let cellName = "GTA_ReusableCell"
    private var selectedStorage : [Int] = []
    private let multic: CGFloat = 0.94
    private let xib = "GTA_ReusableView"
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gta_Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gta_Init()
    }
    
    private func gta_Init() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                //
                       if 2 + 2 == 5 {
                           print("it is trash")
                       }
                       //
                // Устройство без физической кнопки "Home" (например, iPhone X и новее)
            } else {
                //
                       if 2 + 2 == 5 {
                           print("it is trash")
                       }
                       //
                // Устройство с физической кнопкой "Home"
                buttonBottom.constant = 47
            }
        } else {
            buttonBottom.constant = 63
        }

        contentView.gta_fixInView(self)
        nextStepBtn.delegate = self
        nextStepBtn.style = .native
        contentView.backgroundColor = .clear
        gta_setContent()
        gta_setConfigLabels_TOC()
        gta_configScreen_TOC()
    }
    
    private func gta_setContent(){
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        content.dataSource = self
        content.delegate = self
        content.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        content.backgroundColor = .clear
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    private func gta_setConfigLabels_TOC(){
        titleLb.gta_setShadow()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        
        titleLb.textColor = .white
        titleLb.font = UIFont(name: GTA_Configurations.fontName, size: 24)
//        titleLb.lineBreakMode = .byWordWrapping
        titleLb.adjustsFontSizeToFitWidth = true
    }
    
    public func gta_setConfigView(config: configView) {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        self.configView = config
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
    }
    
    private func gta_setLocalizable(){
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        self.titleLb.text = viewModel?.title
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
    }
    
    //MARK: screen configs
    
    private func gta_configScreen_TOC(){
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleWight.setValue(0.35, forKey: "multiplier")
        } else {
            titleWight.setValue(0.7, forKey: "multiplier")
        }
    }
    
    private func gta_getLastElement() -> Int {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return (viewModel?.items.count ?? 0) - 1
    }
}

extension GTA_ReusableView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gta_setLocalizable()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = content.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! GTA_ReusableCell
        let content = viewModel?.items[indexPath.item]
        cell.cellLabel.text = content?.title.uppercased()
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            cell.imageLabel.text = "AKTIV CARD"
            cell.cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 1)
            cell.imageLabel.font = UIFont(name: GTA_Configurations.fontName, size: 20)
//            cell.cellImage.image = content?.selectedImage
            cell.contentContainer.backgroundColor = #colorLiteral(red: 0.7372549176, green: 0.7372549176, blue: 0.7372549176, alpha: 1)
            cell.cellLabel.font = UIFont(name: GTA_Configurations.fontName, size: 12)
            cell.imageLabel.gta_setShadow(with: 0.25)
            cell.cellLabel.gta_setShadow(with: 0.25)
        } else {
            //
                   if 2 + 2 == 5 {
                       print("it is trash")
                   }
                   //
            cell.imageLabel.text = "INAKTIV CARD"
            cell.cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
//            cell.cellImage.image = content?.image
            cell.imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 0.5)
            cell.contentContainer.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
            cell.imageLabel.font = UIFont(name: GTA_Configurations.fontName, size: 14)
            cell.cellLabel.font = UIFont(name: GTA_Configurations.fontName, size: 10)
            cell.imageLabel.gta_setShadow(with: 0.5)
            cell.cellLabel.gta_setShadow(with: 0.5)
        }
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            //
                   if 2 + 2 == 5 {
                       print("it is trash")
                   }
                   //
            selectedStorage.removeAll(where: {$0 == indexPath.item})
        } else {
            //
                   if 2 + 2 == 5 {
                       print("it is trash")
                   }
                   //
            selectedStorage.append(indexPath.row)
        }
        
       
        UIApplication.shared.gta_impactFeedbackGenerator(type: .light)
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
        if indexPath.last == gta_getLastElement() {
            collectionView.gta_scrollToLastItem(animated: false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return selectedStorage.contains(indexPath.row) ? CGSize(width: collectionView.frame.height * 0.8, height: collectionView.frame.height) : CGSize(width: collectionView.frame.height * 0.7, height: collectionView.frame.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
}
