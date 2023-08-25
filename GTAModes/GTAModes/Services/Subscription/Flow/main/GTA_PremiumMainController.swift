import UIKit
import AVKit
import AVFoundation

protocol GTA_PremiumMainControllerDelegate_MEX: AnyObject {
    func gta_funcProductBuyed()
}


enum GTA_PremiumMainControllerStyle {
    case mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther
}

class GTA_PremiumMainController: UIViewController {
    
    private weak var player: Player!
    private var view0 = GTA_ReusableView()
    private var view1 = GTA_ReusableView()
    private var viewTransaction = GTA_TransactionView()
    
    @IBOutlet private weak var freeform: UIView!
    @IBOutlet private weak var videoElement: UIView!
    @IBOutlet private weak var restoreBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var productBuy : GTA_PremiumMainControllerStyle = .mainProduct
    weak var delegate: GTA_PremiumMainControllerDelegate_MEX?

    private var intScreenStatus = 0
    
    override  func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gta_initVideoElement()
        gta_startMaked()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !GTA_NetworkStatusMonitor.shared.isNetworkAvailable {
            gta_showMess()
        }
    }
    
    deinit {
        gta_deinitPlayer()
    }
    
    private func gta_initVideoElement(){
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            GTA_BGPlayer()
        }
    }
    
    
    //MARK: System events
    
    private func gta_deinitPlayer() {
        if let player {
          self.player.volume = 0
          self.player.url = nil
          self.player.didMove(toParent: nil)
        }
        player = nil
      }

    // MARK: - Setup Video Player

    private func GTA_BGPlayer() {
        var pathUrl = Bundle.main.url(forResource: GTA_ConfigurationMediaSub.nameFileVideoForPhone, withExtension: GTA_ConfigurationMediaSub.videoFileType)
        if UIDevice.current.userInterfaceIdiom == .pad {
            pathUrl = Bundle.main.url(forResource: GTA_ConfigurationMediaSub.nameFileVideoForPad, withExtension: GTA_ConfigurationMediaSub.videoFileType)
        }else{
            pathUrl = Bundle.main.url(forResource: GTA_ConfigurationMediaSub.nameFileVideoForPhone, withExtension: GTA_ConfigurationMediaSub.videoFileType)
        }

       let player = Player()
        player.muted = true
        player.playerDelegate = self
        player.playbackDelegate = self
        player.view.frame = self.view.bounds

        addChild(player)
        view.addSubview(player.view)
        player.didMove(toParent: self)
        player.url = pathUrl
        if UIDevice.current.userInterfaceIdiom == .pad {
            player.playerView.playerFillMode = .resizeAspectFill
        }else{
            player.playerView.playerFillMode = .resize
        }
        player.playbackLoops = true
        view.sendSubviewToBack(player.view)
        self.player = player
    }
    
    private func loopVideoMB(videoPlayer:AVPlayer){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
    
    // MARK: - Make UI/UX
    
    private func gta_startMaked() {
        gta_setRestoreBtn()
        if productBuy == .mainProduct {
            gta_setReusable(config: .first, isHide: false)
            gta_setReusable(config: .second, isHide: true)
            gta_setTransaction(isHide: true)
        } else {
            gta_setTransaction(isHide: false)
            self.gta_showRestore()
        }
    }
    
    //reusable setup
    
    private func gta_generateContentForView(config: configView) -> [ReusableContentCell] {
        var contentForCV : [ReusableContentCell] = []
        switch config {
        case .first:
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .second:
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .transaction: return contentForCV
        }
    }
    
    private func gta_setReusable(config : configView, isHide : Bool){
        var currentView : GTA_ReusableView? = nil
        var viewModel : ReusableViewModel? = nil
        switch config {
        case .first:
            viewModel =  ReusableViewModel(title: localizedString(forKey: "TextTitle1ID").uppercased(), items: self.gta_generateContentForView(config: config))
            currentView = self.view0
        case .second:
            viewModel =  ReusableViewModel(title: localizedString(forKey: "TextTitle2ID").uppercased(), items: self.gta_generateContentForView(config: config))
            currentView = self.view1
        case .transaction:
            currentView = nil
        }
        guard let i = currentView else { return }
        i.protocolElement = self
        i.viewModel = viewModel
        i.configView = config
        freeform.addSubview(i)
        freeform.bringSubviewToFront(i)
        
        i.snp.makeConstraints { make in
            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        i.isHidden = isHide
    }
    //transaction setup
    
    private func gta_setTransaction( isHide : Bool) {
        self.viewTransaction.inapp.productBuy = self.productBuy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewTransaction.gta_setLocalization_TOC()
        }
        freeform.addSubview(self.viewTransaction)
        freeform.bringSubviewToFront(self.viewTransaction)
        self.viewTransaction.inapp.productBuy = self.productBuy
        self.viewTransaction.snp.makeConstraints { make in
            //            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        self.viewTransaction.isHidden = isHide
        self.viewTransaction.delegate = self
    }
    
    // restore button setup
    
    private func gta_setRestoreBtn(){
        self.restoreBtn.isHidden = true
        self.restoreBtn.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        self.restoreBtn.setTitle(localizedString(forKey: "restore"), for: .normal)
        self.restoreBtn.titleLabel?.gta_setShadow()
        self.restoreBtn.tintColor = .white
        self.restoreBtn.setTitleColor(.white, for: .normal)
    }
    
//    private func gta_openApp(){
//        let vc = MainAppController()
//        UIApplication.shared.setRootVC(vc)
//        UIApplication.shared.gta_notificationFeedbackGenerator(type: .success)
//        gta_deinitPlayer()
//    }
    
    private func gta_openApp(){
        if productBuy == .mainProduct {
            gta_openMainFlow()
            gta_deinitPlayer()
            
        } else {
            delegate?.gta_funcProductBuyed()
            dismiss(animated: true)
            
            
        }
    }
    
    private func gta_openMainFlow() {
        let flowCoordinator = GTAModes_MainFlowCoordinator()
        let controller = flowCoordinator.gta_createFlow()
        controller.modalPresentationStyle = .fullScreen
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.setNavigationBarHidden(true, animated: false)
        
        UIApplication.shared.gta_setRootVC(navigation)
        UIApplication.shared.gta_notificationFeedbackGenerator(type: .success)
    }


    
    private func gta_showRestore(){
        self.restoreBtn.isHidden = false
        if productBuy != .mainProduct {
            self.closeBtn.isHidden = false
        }
    }
    
    @IBAction func gta_restoreAction(_ sender: UIButton) {
        self.viewTransaction.gta_restoreAction()
    }
    
    @IBAction func gta_closeController(_ sender: UIButton) {
        gta_openApp()
    }
}

extension GTA_PremiumMainController : ReusableViewEvent {
    func gta_nextStep(config: configView) {
        switch config {
        case .first:
            self.view0.gta_fadeOut()
            self.view1.gta_fadeIn()
            UIApplication.shared.gta_impactFeedbackGenerator(type: .medium)
            GTA_ThirdPartyServicesManager.shared.gta_makeATT()
        case .second:
            self.view1.gta_fadeOut()
            self.viewTransaction.gta_fadeIn()
            self.gta_showRestore()
            //            self.viewTransaction.title.restartpageControl()
            UIApplication.shared.gta_impactFeedbackGenerator(type: .medium)
        case .transaction: break
        }
    }
}

extension GTA_PremiumMainController: GTA_NetworkStatusMonitorDelegate {
    func gta_showMess() {
        gta_transactionTreatment_TOC(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
}

extension GTA_PremiumMainController : GTA_TransactionViewEvents {
    
    func gta_userSubscribed() {
        self.gta_openApp()
    }
    
    func gta_transactionTreatment_TOC(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        UIApplication.shared.gta_notificationFeedbackGenerator(type: .warning)
    }
    
    func gta_transactionFailed() {
        print(#function)
        UIApplication.shared.gta_notificationFeedbackGenerator(type: .error)
    }
    
    func gta_privacyOpen() {
        GTA_Configurations.policyLink.gta_openURL()
    }
    
    func gta_termsOpen() {
        GTA_Configurations.termsLink.gta_openURL()
    }
}

extension GTA_PremiumMainController: PlayerDelegate, PlayerPlaybackDelegate {
    func playerReady(_ player: Player) { }

    func playerPlaybackStateDidChange(_ player: Player) { }

    func playerBufferingStateDidChange(_ player: Player) { }

    func playerBufferTimeDidChange(_ bufferTime: Double) { }

    func player(_ player: Player, didFailWithError error: Error?) { }

    func playerCurrentTimeDidChange(_ player: Player) { }

    func playerPlaybackWillStartFromBeginning(_ player: Player) { }

    func playerPlaybackDidEnd(_ player: Player) { }

    func playerPlaybackWillLoop(_ player: Player) { }

    func playerPlaybackDidLoop(_ player: Player) { }
}

