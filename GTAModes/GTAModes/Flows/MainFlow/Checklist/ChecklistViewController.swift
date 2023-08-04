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
        setupBackButton()
        customizeNavigationBar()
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
    
    private func setupBackButton() {
        let image = UIImage(named: "backIcon")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func customizeNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Checklist"
        titleLabel.font = UIFont(name: "Inter-Bold", size: 30)
        titleLabel.textColor = .white
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layout {
            $0.trailing.equal(to: titleView.trailingAnchor)
            $0.centerY.equal(to: titleView.centerYAnchor)
        }
        navigationItem.titleView = titleView
    }
    
    @objc
    private func leftBarButtonTapped() {
        model.backActionProceed()
    }
    
    private func setupFilterButton() {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    @objc
    private func filterButtonAction() {
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

