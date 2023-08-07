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
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    init(model: GameModesModel) {
        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        setupView()
        setupBackButton()
        customizeNavigationBar("some game")
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
        tableView.rowHeight = 96.0
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
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search here"
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "checkCellBlue")?.withAlphaComponent(0.4)
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.tintColor = .white
        searchController.searchBar.barStyle = .default
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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

extension GameModesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        print(searchBarText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //    viewModel.cancelSearch()
    }
    
}

