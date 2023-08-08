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
    private let customNavigation: CustomNavigationView
    
    init(model: ChecklistModel) {
        self.model = model
        self.customNavigation = CustomNavigationView(.checkList)
        super.init()
        
        customNavigation.leftButtonAction = { [weak self] in
            self?.model.backActionProceed()
        }
        customNavigation.rightButtonAction = { [weak self] in
            self?.model.filterActionProceed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
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
        tableView.registerReusableCell(cellType: ChecklistCell.self)
        tableView.rowHeight = 82.0
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

