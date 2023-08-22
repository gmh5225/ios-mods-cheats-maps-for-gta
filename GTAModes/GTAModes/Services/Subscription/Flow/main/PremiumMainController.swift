import UIKit
import AVKit
import AVFoundation

enum PremiumMainControllerStyle {
    case mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther
}

protocol GTA_PremiumMainControllerDelegate_MEX: AnyObject {
    func gta_funcProductBuyed()
}

class PremiumMainController: UIViewController {
    
    private var playerLayer : AVPlayerLayer!
    private var view0 = ReusableView()
    private var view1 = ReusableView()
    private var viewTransaction = TransactionView()
    
    @IBOutlet private weak var freeform: UIView!
    @IBOutlet private weak var videoElement: UIView!
    @IBOutlet private weak var restoreBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var productBuy : PremiumMainControllerStyle = .mainProduct
    weak var delegate: GTA_PremiumMainControllerDelegate_MEX?
    
    private var intScreenStatus = 0
    private var avPlayer: AVPlayer? = AVPlayer()
    
    
    
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
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gta_deinitOperation()
    }
    
    override  func viewDidDisappear(_ animated: Bool) {
        gta_chageScreenStatus()
    }
    
    deinit {
        gta_deinitOperation()
    }
    
    private func gta_initVideoElement(){
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            GTA_BGPlayer()
        }
    }
    
    
    //MARK: System events
    
    private func gta_deinitOperation(){
        intScreenStatus = 1
        avPlayer?.pause()
        avPlayer?.replaceCurrentItem(with: nil)
        if playerLayer != nil {
            playerLayer.player = nil
        }
        avPlayer = nil
        playerLayer = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    private func gta_chageScreenStatus(){
        intScreenStatus = 1
        avPlayer?.pause()
    }
    
    
    
    // MARK: - Setup Video Player
    
    private func GTA_BGPlayer(){
        var pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub.nameFileVideoForPhone, withExtension: ConfigurationMediaSub.videoFileType)
        if UIDevice.current.userInterfaceIdiom == .pad {
            pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub.nameFileVideoForPad, withExtension: ConfigurationMediaSub.videoFileType)
        }else{
            pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub.nameFileVideoForPhone, withExtension: ConfigurationMediaSub.videoFileType)
        }
        
        avPlayer = AVPlayer(url: pathUrl!)
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.view.layer.bounds
        if UIDevice.current.userInterfaceIdiom == .pad{
            playerLayer.videoGravity = .resizeAspectFill
        }else{
            playerLayer.videoGravity = .resize
        }
        self.videoElement.layer.addSublayer(playerLayer)
        avPlayer?.play()
        
        if let avPlayer {
            gta_loopVideoMB(videoPlayer: avPlayer)
        }
        gta_addPlayerNotifications()
    }
    
    private func gta_addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(gta_playerItemDidPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gta_applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gta_applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gta_handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    private func gta_loopVideoMB(videoPlayer:AVPlayer){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
    
    @objc func gta_handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        if type == .began {
            // Interruption began, take appropriate actions (save state, update user interface)
            self.avPlayer?.pause()
        } else if type == .ended {
            guard let optionsValue =
                    info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption Ended - playback should resume
                self.avPlayer?.play()
            }
        }
    }
    
    // Player end.
    @objc  private func gta_playerItemDidPlayToEnd(_ notification: Notification) {
        // Your Code.
        if intScreenStatus == 0{
            avPlayer?.seek(to: CMTime.zero)
        }
    }
    
    //App enter in forground.
    @objc private func gta_applicationWillEnterForeground(_ notification: Notification) {
        if intScreenStatus == 0 {
            avPlayer?.play()
        } else {
            avPlayer?.pause()
        }
    }
    
    //App enter in forground.
    @objc private func gta_applicationDidEnterBackground(_ notification: Notification) {
        avPlayer?.pause()
    }
    
    // MARK: - Make UI/UX
    
    private func gta_startMaked(){
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
    
    private func generateContentForView(config: configView) -> [GTA_ReusableContentCell] {
        var contentForCV : [GTA_ReusableContentCell] = []
        switch config {
        case .first:
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .second:
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(GTA_ReusableContentCell(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .transaction: return contentForCV
        }
    }
    
    private func gta_setReusable(config : configView, isHide : Bool){
        var currentView : ReusableView? = nil
        var viewModel : GTA_ReusableViewModel? = nil
        switch config {
        case .first:
            viewModel =  GTA_ReusableViewModel(title: localizedString(forKey: "TextTitle1ID").uppercased(), items: self.generateContentForView(config: config))
            currentView = self.view0
        case .second:
            viewModel =  GTA_ReusableViewModel(title: localizedString(forKey: "TextTitle2ID").uppercased(), items: self.generateContentForView(config: config))
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
        self.restoreBtn.setTitle(localizedString(forKey: "restore"), for: .normal)
        self.restoreBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 14)
        self.restoreBtn.titleLabel?.gta_setShadow()
        self.restoreBtn.tintColor = .white
        self.restoreBtn.setTitleColor(.white, for: .normal)
    }
    
    private func gta_openApp(){
        if productBuy == .mainProduct {
            gta_openMainFlow()
            
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
    
    @IBAction func restoreAction(_ sender: UIButton) {
        self.viewTransaction.gta_restoreAction()
    }
    
    @IBAction func closeController(_ sender: UIButton) {
        gta_openApp()
    }
}

extension PremiumMainController : GTA_ReusableViewEvent {
    func gta_nextStep(config: configView) {
        switch config {
        case .first:
            self.view0.gta_fadeOut()
            self.view1.gta_fadeIn()
            UIApplication.shared.impactFeedbackGenerator(type: .medium)
            GTA_ThirdPartyServicesManager.shared.gta_makeATT()
        case .second:
            self.view1.gta_fadeOut()
            self.viewTransaction.gta_fadeIn()
            self.gta_showRestore()
            //            self.viewTransaction.title.restartpageControl()
            UIApplication.shared.impactFeedbackGenerator(type: .medium)
        case .transaction: break
        }
    }
}

extension PremiumMainController: GTA_NetworkStatusMonitorDelegate {
    func gta_showMess() {
        gta_transactionTreatment_TOC(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
}

extension PremiumMainController : GTA_TransactionViewEvents {
    func gta_userSubscribed() {
        gta_deinitOperation()
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
