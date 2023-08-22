//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

enum gta_enum_configView {
    case first,second,transaction
}

protocol GTA_ReusableViewEvent : AnyObject {
    func gta_nextStep(config: gta_enum_configView)
}

struct GTA_ReusableViewModel {
    var title : String
    var items : [GTA_ReusableContentCell]
}

struct GTA_ReusableContentCell {
    var title : String
    var image : UIImage
    var selectedImage: UIImage
}

class GTA_ReusableView: UIView, GTA_AnimatedButtonEvent {
    
//
    @IBOutlet private weak var nextStepBtn: AnimatedButton!
    //
    @IBOutlet private weak var titleWight: NSLayoutConstraint!
    //
    @IBOutlet private var contentView: UIView!
    //
    @IBOutlet private weak var titleLb: UILabel!
    //
    @IBOutlet private weak var content: UICollectionView!
    //
    @IBOutlet private weak var buttonBottom: NSLayoutConstraint!
    //
    weak var protocolElement : GTA_ReusableViewEvent?
    //
    public var configView : gta_enum_configView = .first
    public var viewModel : GTA_ReusableViewModel? = nil
    private let cellName = "GTA_ReusableCell"
    private var selectedStorage : [Int] = []
    private let multic: CGFloat = 0.94
    private let xib = "GTA_ReusableView"
    
    private func gta_Init() {
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                // Устройство без физической кнопки "Home" (например, iPhone X и новее)
            } else {
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gta_Init()
    }
    
    private func gta_setContent(){
        content.dataSource = self
        content.delegate = self
        content.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        content.backgroundColor = .clear
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    private func gta_setConfigLabels_TOC(){
        titleLb.gta_setShadow()
        
        titleLb.textColor = .white
        titleLb.font = UIFont(name: "SFProText-Bold", size: 26)
//        titleLb.lineBreakMode = .byWordWrapping
        titleLb.adjustsFontSizeToFitWidth = true
    }
    
    func gta_onClick() {
        self.protocolElement?.gta_nextStep(config: self.configView)
    }
    
    public func gta_setConfigView(config: gta_enum_configView) {
        self.configView = config
    }
    
    private func gta_setLocalizable(){
        self.titleLb.text = viewModel?.title
    }
    
    //MARK: screen configs
    
    private func gta_configScreen_TOC(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleWight.setValue(0.35, forKey: "multiplier")
        } else {
            titleWight.setValue(0.7, forKey: "multiplier")
        }
    }
    
    private func gta_getLastElement() -> Int {
        return (viewModel?.items.count ?? 0) - 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        gta_Init()
    }
}

extension GTA_ReusableView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gta_setLocalizable()
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = content.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! GTA_ReusableCell
        
        let content = viewModel?.items[indexPath.item]
        
        cell.cellLabel.text = content?.title
        
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            cell.cellImage.image = content?.selectedImage
        } else {
            cell.cellImage.image = content?.image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            selectedStorage.removeAll(where: {$0 == indexPath.item})
        } else {
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
        return selectedStorage.contains(indexPath.row) ? CGSize(width: collectionView.frame.height * 0.8, height: collectionView.frame.height) : CGSize(width: collectionView.frame.height * 0.7, height: collectionView.frame.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
}
