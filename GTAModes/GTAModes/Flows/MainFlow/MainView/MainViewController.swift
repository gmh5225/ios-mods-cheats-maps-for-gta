//
//  MainViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit
import Combine

class MainViewController: NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: MainModel
    private let tableView = UITableView(frame: .zero)
    
    init(model: MainModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
    }
    
    private func setupView() {
        navigationItem.title = ""
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.pinEdges(to: view)
        tableView.registerReusableCell(cellType: MainTableViewCell.self)
        tableView.rowHeight = 228.0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        model.reloadData
          .sink { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
          }.store(in: &subscriptions)
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.menuItems[indexPath.row], fontSize: 30.0)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectedItems(index: indexPath.row)
    }
    
}
