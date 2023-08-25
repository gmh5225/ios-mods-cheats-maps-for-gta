//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

protocol GTA_TransactionViewEvents : AnyObject {
    func gta_userSubscribed()
    func gta_transactionTreatment_TOC(title: String, message: String)
    func gta_transactionFailed()
    func gta_privacyOpen()
    func gta_termsOpen()
}

class GTA_TransactionView: UIView,GTA_AnimatedButtonEvent,GTA_IAPManagerProtocol, GTA_NetworkStatusMonitorDelegate {
    func gta_showMess() {
        gta_transactionTreatment_TOC(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
    
    
    private let xib = "GTA_TransactionView"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private(set) weak var title: UILabel!
    @IBOutlet private weak var sliderStack: UIStackView!
    @IBOutlet private weak var trialLb: UILabel!
    @IBOutlet private weak var descriptLb: UILabel!
    @IBOutlet private weak var purchaseBtn: GTA_AnimatedButton!
    @IBOutlet private weak var privacyBtn: UIButton!
    @IBOutlet private weak var policyBtn: UIButton!
    @IBOutlet private weak var trialWight: NSLayoutConstraint!
    @IBOutlet private weak var sliderWight: NSLayoutConstraint!
    @IBOutlet private weak var sliderTop: NSLayoutConstraint!
    @IBOutlet private weak var conteinerWidth: NSLayoutConstraint!
    @IBOutlet private weak var heightView: NSLayoutConstraint!
    
    
    private let currentFont = GTA_Configurations.fontName
    public let inapp = GTA_IAPManager.shared
    private let locale = NSLocale.current.languageCode
    public weak var delegate : GTA_TransactionViewEvents?
    private let networkingMonitor = GTA_NetworkStatusMonitor.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gta_Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gta_Init()
    }
    
    private func gta_Init() {
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                heightView.constant = 163
            } else {
//                sliderTop.constant = 60
                heightView.constant = 152
            }
        } else {
            conteinerWidth.constant = 400
            heightView.constant = 167
//            sliderTop.constant = 45
        }
        contentView.gta_fixInView(self)
        contentView.backgroundColor = .clear
        gta_buildConfigs_TOC()
    }
    
    private func gta_buildConfigs_TOC(){
        gta_configScreen_TOC()
        gta_setSlider_TOC()
        gta_setConfigLabels_TOC()
        gta_setConfigButtons_TOC()
        gta_setLocalization_TOC()
        gta_configsInApp_TOC()
    }
    
    private func gta_setSlider_TOC(){
        
        title.text = (localizedString(forKey: "SliderID1").uppercased())
        var texts: [String] = ["\(localizedString(forKey: "SliderID2"))",
                               "\(localizedString(forKey: "SliderID3"))",
                               "\(localizedString(forKey: "SliderID4"))",
                               ]
        for t in texts {
            sliderStack.addArrangedSubview(GTA_SliderCellView(title: t, subTitle: t.lowercased()))
        }
    }
    
    //MARK: config labels
    
    private func gta_setConfigLabels_TOC(){
        //slider
        title.textColor = .white
        title.font = UIFont(name: currentFont, size: 24)
//        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 4
        title.gta_setShadow()
        title.lineBreakMode = .byClipping
        if UIDevice.current.userInterfaceIdiom == .pad {
            title.font = UIFont(name: currentFont, size: 24)
        }
        trialLb.gta_setShadow()
        trialLb.font = UIFont(name: currentFont, size: 13)
        trialLb.textColor = .white
        trialLb.textAlignment = .center
        trialLb.numberOfLines = 2
        trialLb.adjustsFontSizeToFitWidth = true
        
        descriptLb.gta_setShadow()
        descriptLb.textColor = .white
        descriptLb.textAlignment = .center
        descriptLb.numberOfLines = 0
        descriptLb.font = UIFont.systemFont(ofSize: 15)
        
        privacyBtn.titleLabel?.gta_setShadow()
        privacyBtn.titleLabel?.numberOfLines = 2
        privacyBtn.titleLabel?.textAlignment = .center
        
        privacyBtn.setTitleColor(.white, for: .normal)
        privacyBtn.tintColor = .white
        
        policyBtn.titleLabel?.gta_setShadow()
        policyBtn.titleLabel?.numberOfLines = 2
        policyBtn.titleLabel?.textAlignment = .center
        policyBtn.setTitleColor(.white, for: .normal)
        policyBtn.tintColor = .white
        privacyBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
        policyBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
    }
    
    //MARK: config button
    
    private func gta_setConfigButtons_TOC(){
        self.purchaseBtn.delegate = self
        self.purchaseBtn.style = .native
    }
    
    //MARK: config localization
    
    public func gta_setLocalization_TOC() {
        
//        title.labelTextsForSlider = "\(localizedString(forKey: "SliderID1").uppercased())|n\(localizedString(forKey: "SliderID2").uppercased())|n\(localizedString(forKey: "SliderID3").uppercased()) |n\(localizedString(forKey: "SliderID4").uppercased()) |n\(localizedString(forKey: "SliderID5").uppercased())"
        
        let description = localizedString(forKey: "iOSAfterID")
        let localizedPrice = inapp.gta_localizedPrice()
        descriptLb.text = String(format: description, localizedPrice)
        
        if locale == "en" {
            trialLb.text = "Start 3-days for FREE\n Then \(localizedPrice)/week".uppercased()
        } else {
            trialLb.text = ""
        }
        privacyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        privacyBtn.setAttributedTitle(localizedString(forKey: "TermsID").underLined, for: .normal)
        policyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        policyBtn.setAttributedTitle(localizedString(forKey: "PrivacyID").underLined, for: .normal)
    }
    
    //MARK: screen configs
    
    private func gta_configScreen_TOC(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            trialWight.setValue(0.28, forKey: "multiplier")
            sliderWight.setValue(0.5, forKey: "multiplier")
        } else {
            trialWight.setValue(0.46, forKey: "multiplier")
            sliderWight.setValue(0.8, forKey: "multiplier")
        }
    }
    
    //MARK: configs
    
    private func gta_configsInApp_TOC(){
        self.inapp.transactionsDelegate = self
        self.networkingMonitor.delegate = self
    }
    
    public func gta_restoreAction(){
        inapp.gta_doRestore()
    }
    
    //MARK: actions
    
    @IBAction func gta_privacyAction(_ sender: UIButton) {
        
        self.delegate?.gta_termsOpen()
    }
    
    @IBAction func gta_termsAction(_ sender: UIButton) {
        self.delegate?.gta_privacyOpen()
    }
    
    func gta_onClick() {
        UIApplication.shared.gta_impactFeedbackGenerator(type: .heavy)
        networkingMonitor.gta_startMonitoring()
        inapp.gta_doPurchase()
        purchaseBtn.isUserInteractionEnabled = false
    }
    
    //inapp
    
    func gta_transactionTreatment_TOC(title: String, message: String) {
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.gta_transactionTreatment_TOC(title: title, message: message)
    }
    
    func gta_infoAlert(title: String, message: String) {
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.gta_transactionTreatment_TOC(title: title, message: message)
    }
    
    func gta_goToTheApp() {
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.gta_userSubscribed()
    }
    
    func gta_failed() {
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.gta_transactionFailed()
    }
}
