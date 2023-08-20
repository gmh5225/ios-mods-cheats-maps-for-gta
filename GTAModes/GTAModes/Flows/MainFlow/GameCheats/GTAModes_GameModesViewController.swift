//
//  GameModesViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import UIKit
import Combine

class GTAModes_GameModesViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GTAModes_GameModesModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let customNavigation: GTAModes_CustomNavigationView
    private let searchContainer = UIView()
    private var searchBar: GTAModes_SearchBar?
    
    init(model: GTAModes_GameModesModel) {
        self.model = model
        self.customNavigation = GTAModes_CustomNavigationView(.gameModes, titleString: model.title)
        
        super.init()
        
        customNavigation.leftButtonAction = { [weak self] in
            self?.model.gta_backActionProceed()
        }
        customNavigation.rightButtonAction = { [weak self] in
            self?.model.gta_filterActionProceed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gta_setupView()
        gta_setupBindings()
        gta_setupSearchBar()
        gta_searchBindings()
    }
    
    private func gta_setupView() {
        view.addSubview(customNavigation)
        customNavigation.layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor, offsetBy: 21.0)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        
        view.addSubview(searchContainer)
        searchContainer.layout {
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 16.0)
            $0.leading.equal(to: view.safeAreaLayoutGuide.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.safeAreaLayoutGuide.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 42)
        }
        searchContainer.backgroundColor = UIColor(named: "checkCellBlue")?.withAlphaComponent(0.4)
        searchContainer.withCornerRadius(20.0)
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.layout {
            $0.top.equal(to: searchContainer.bottomAnchor)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
        }
        tableView.sectionHeaderHeight = 140.0
        tableView.registerReusableCell(cellType: GTAModes_GameModesTableViewCell.self)
        tableView.registerReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96.0
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func gta_setupBindings() {
        model.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }.store(in: &subscriptions)
        
    }
    
    private func gta_setupSearchBar() {
        let searchViewModel = GameModesSearchViewModel()
        searchBar = GTAModes_SearchBar(viewModel: searchViewModel)
        searchContainer.addSubview(searchBar!)
        searchBar?.layout {
            $0.top.equal(to: searchContainer.topAnchor, offsetBy: -1.0)
            $0.leading.equal(to: searchContainer.leadingAnchor, offsetBy: -1.0)
            $0.trailing.equal(to: searchContainer.trailingAnchor, offsetBy: 1.0)
            $0.bottom.equal(to: searchContainer.bottomAnchor, offsetBy: 1.0)
        }
    }
    
    private func gta_searchBindings() {
        if let searchBar = searchBar {
            searchBar.$text.dropFirst().sink { [weak self] searchText in
                self?.model.gta_searchAt(searchText)
            }.store(in: &subscriptions)
            
            searchBar.textDidEndEditing.sink { [ weak self ] _ in
                self?.model.gta_searchDidCancel()
            }.store(in: &subscriptions)
            
        }
    }
    
}

extension GTAModes_GameModesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_GameModesTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.gameMode_configure_cell(model.cheatItems[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cheatItems.count
    }
    
}

extension GTAModes_GameModesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        headerView?.actionButton = { [weak self] index in
            self?.model.gta_showCheats(CheatsType.allCases[index])
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.gta_actionAt(index: indexPath.row)
    }
    
}

final class GameModesSearchViewModel: GTAModes_SearchBarViewModelApplicable {
    
    var showsCancelButton: Bool {
        false
    }
    
}
