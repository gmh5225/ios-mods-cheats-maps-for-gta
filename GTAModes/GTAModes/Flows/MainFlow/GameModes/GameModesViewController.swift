//
//  GameModesViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import UIKit
import Combine

class GameModesViewController: NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GameModesModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let customNavigation: CustomNavigationView
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    init(model: GameModesModel) {
        self.model = model
        self.customNavigation = CustomNavigationView(.gameModes, titleString: model.title)
        
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
        
        configureSearchController()
        setupView()
        setupBindings()
        
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
        tableView.sectionHeaderHeight = 140.0
        tableView.registerReusableCell(cellType: GameModesTableViewCell.self)
        tableView.registerReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        tableView.rowHeight = 96.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func setupBindings() {
        model.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }.store(in: &subscriptions)
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
    
}

extension GameModesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameModesTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.configure(model.cheatItems[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cheatItems.count
    }
    
}

extension GameModesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        headerView?.actionButton = { [weak self] index in
            self?.model.showCheats(CheatsType.allCases[index])
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.actionAt(index: indexPath.row)
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

