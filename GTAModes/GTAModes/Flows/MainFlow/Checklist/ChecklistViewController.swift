//
//  ChecklistViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import UIKit

class ChecklistViewController: NiblessViewController {
    
    private let model: ChecklistModel
    private let tableView = UITableView(frame: .zero)
    
    init(model: ChecklistModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBackToMenuButton()
        customizeNavigationBar("Checklist")
        setupFilterButton()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.pinEdges(to: view)
        tableView.registerReusableCell(cellType: ChecklistCell.self)
        tableView.rowHeight = 82.0
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    override func leftBarButtonTapped() {
        model.backActionProceed()
    }
    
    @objc
    override func filterButtonAction() {
        model.filterActionProceed()
    }
    
}

extension ChecklistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChecklistCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.menuItems[indexPath.row])
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menuItems.count
    }
    
}

