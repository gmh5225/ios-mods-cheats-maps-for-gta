//
//  GSViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import UIKit

class GSViewController: NiblessViewController {
    
    private let model: GSModel
    
    private let tableView = UITableView(frame: .zero)
    
    init(model: GSModel) {
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
}

extension GSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.menuItems[indexPath.row], fontSize: 24.0)
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
