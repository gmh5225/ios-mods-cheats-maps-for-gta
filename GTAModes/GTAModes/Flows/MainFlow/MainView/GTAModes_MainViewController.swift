//
//  MainViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit
import Combine

class GTAModes_MainViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GTAModes_MainModel
    private let tableView = UITableView(frame: .zero)
    var alert: UIAlertController?
    
    init(model: GTAModes_MainModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if model.menuItems.isEmpty {
            gta_showSpiner()
        }
        gta_setupView()
        gta_setupBindings()
    }
    
    private func gta_setupView() {
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
        tableView.rowHeight = 228.0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func gta_setupBindings() {
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
    
    private func gta_showSpiner() {
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
            if GTA_IAPManager.shared.productBought.contains(.unlockFuncProduct) {
                cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: false)
            } else {
                cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: true)
            }
        } else if indexPath.row == 3 {
            if GTA_IAPManager.shared.productBought.contains(.unlockContentProduct) {
                cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: false)
            } else {
                cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: true)
            }
        } else {
            cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0, isLock: false)
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            if GTA_IAPManager.shared.productBought.contains(.unlockFuncProduct) {
                model.gta_selectedItems(index: indexPath.row)
            } else if indexPath.row == 3 {
                if GTA_IAPManager.shared.productBought.contains(.unlockContentProduct) {
                    model.gta_selectedItems(index: indexPath.row)
                } else {
                    showSub(.unlockContentProduct)
                }
            }
            
        }
    }
        
        func showSub(_ premiumSub: gta_PremiumMainControllerStyle) {
            let withPremiumVC = PremiumMainController()
            withPremiumVC.productBuy = premiumSub
            withPremiumVC.delegate = self
            navigationController?.present(withPremiumVC, animated: false)
        }
        
    }
    
    extension GTAModes_MainViewController: GTA_PremiumMainControllerDelegate_MEX {
        
        func gta_funcProductBuyed() {
            tableView.reloadData()
        }
        
    }
