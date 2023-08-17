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
    
    init(model: GTAModes_MainModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gta_setupView()
        gta_setupBindings()
    }
    
    private func gta_setupView() {
        navigationItem.title = ""
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.pinEdges(to: view)
        tableView.registerReusableCell(cellType: GTAModes_MainTableViewCell.self)
        tableView.rowHeight = 228.0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func gta_setupBindings() {
        model.reloadData
          .sink { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
          }.store(in: &subscriptions)
    }
    
}

extension GTAModes_MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.gta_configure(model.menuItems[indexPath.row], fontSize: 30.0)
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
