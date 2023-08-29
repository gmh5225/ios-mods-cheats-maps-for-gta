
import UIKit
import Combine

class GTAModes_MainViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    //
    private let model: GTAModes_MainModel
    //
    private let tableView = UITableView(frame: .zero)
    //
    var alert: UIAlertController?
    
    var mapIsLock: Bool = false
    var modeIsLock: Bool = false
    
    private func gta_checkSub() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        GTA_IAPManager.shared.gta_validateSubscriptions(
            productIdentifiers: [
                GTA_Configurations.unlockFuncSubscriptionID,
                GTA_Configurations.unlockContentSubscriptionID
            ]) { [weak self] results in

                self?.mapIsLock = results[GTA_Configurations.unlockFuncSubscriptionID] ?? false
                self?.modeIsLock = results[GTA_Configurations.unlockContentSubscriptionID] ?? false
                self?.tableView.reloadData()
            }
    }
    
    private func gta_setupView() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        navigationItem.title = ""
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.gta_layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor, offsetBy: 21.0)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
        }
        tableView.registerReusableCell(cellType: GTAModes_MainTableViewCell.self)
        tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 360.0 : 228.0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    init(model: GTAModes_MainModel) {
        self.model = model
        
        super.init()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
    }
    
    private func gta_setupBindings() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        model.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }.store(in: &subscriptions)
        
        model.hideSpiner = { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
            self.gta_hideSpiner()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        
        gta_checkSub()
        if model.menuItems.isEmpty {
            gta_showSpiner()
        }
        gta_setupView()
        gta_setupBindings()
    }
    
    private func gta_showSpiner() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        alert = UIAlertController(title: nil, message: "Load Data", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alert?.view.addSubview(loadingIndicator)
        
        present(alert!, animated: true, completion: nil)
        
    }
    
    private func gta_hideSpiner() {
        alert?.dismiss(animated: false)
    }
    
}

extension GTAModes_MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        if indexPath.row == 2 {
            cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: !mapIsLock)
        } else if indexPath.row == 3 {
            cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: !modeIsLock)
        } else {
            cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: false)
        }
        
        cell.backgroundColor = .clear
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        model.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if indexPath.row == 2 {
            if mapIsLock {
                model.gta_selectedItems(index: indexPath.row)
            } else {
                showSub(.unlockFuncProduct)
            }
        } else if indexPath.row == 3 {
            if modeIsLock {
                model.gta_selectedItems(index: indexPath.row)
            } else {
                showSub(.unlockContentProduct)
            }
        } else {
            model.gta_selectedItems(index: indexPath.row)
        }
    }
    
    func showSub(_ premiumSub: GTA_PremiumMainControllerStyle) {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        let withPremiumVC = GTA_PremiumMainController()
        withPremiumVC.modalPresentationStyle = .overFullScreen
        withPremiumVC.productBuy = premiumSub
        withPremiumVC.delegate = self
        navigationController?.present(withPremiumVC, animated: false)
    }
    
}

extension GTAModes_MainViewController: GTA_PremiumMainControllerDelegate_MEX {
    
    func gta_funcProductBuyed() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        gta_checkSub()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        tableView.reloadData()
    }
    
}
