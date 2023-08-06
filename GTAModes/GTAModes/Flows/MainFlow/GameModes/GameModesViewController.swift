//
//  GameModesViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import UIKit

class GameModesViewController: NiblessViewController {
    
    private let model: GameModesModel
    private let tableView = UITableView(frame: .zero, style: .grouped)

    init(model: GameModesModel) {
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
        navigationItem.title = ""
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 140.0
        tableView.pinEdges(to: view)
        tableView.registerReusableCell(cellType: GameModesTableViewCell.self)
        tableView.registerReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        tableView.rowHeight = 105.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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

extension GameModesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GameModesTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.dataItems[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.dataItems.count
    }
    
}

extension GameModesViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(viewType: GameModesHeaderView.self)
//    headerView?.setTitle(viewModel.title)
    
    return headerView
  }
  
}
