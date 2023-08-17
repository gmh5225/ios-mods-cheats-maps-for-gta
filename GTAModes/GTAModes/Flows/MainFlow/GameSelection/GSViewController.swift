//
//  GSViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import UIKit
import Combine

class GSViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GSModel
    private let tableView = UITableView(frame: .zero)
    private let customNavigation: GTAModes_CustomNavigationView
    
    init(model: GSModel) {
        self.model = model
        self.customNavigation = GTAModes_CustomNavigationView(.gameSelect)
        super.init()
        
        customNavigation.leftButtonAction = { [weak self] in
            self?.model.gta_backActionProceed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gta_setupView()
        gs_setupBindings()
    }
    
    private func gs_setupBindings() {
        model.reloadData
          .sink { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
          }.store(in: &subscriptions)
    }
    
    private func gta_setupView() {
        view.addSubview(customNavigation)
        customNavigation.layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.layout {
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 40.0)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
        }
        tableView.registerReusableCell(cellType: GTAModes_MainTableViewCell.self)
        tableView.rowHeight = 160.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    
    
}

extension GSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GTAModes_MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.gta_configure(model.menuItems[indexPath.row], fontSize: 24.0)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.gta_selectedItems(index: indexPath.row)
    }
    
}
