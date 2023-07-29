//
//  MainViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit

class MainViewController: NiblessViewController {
    
    private let model: MainModel
    
    private let tableView = UITableView(frame: .zero)
    
    init(model: MainModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = ""
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.pinEdges(to: view)
        tableView.registerReusableCell(cellType: MainTableViewCell.self)
        tableView.rowHeight = 228.0
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = true
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.menuItems[indexPath.row])
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
