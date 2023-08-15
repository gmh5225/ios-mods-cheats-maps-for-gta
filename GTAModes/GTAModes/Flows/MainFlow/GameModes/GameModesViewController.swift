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
    private let searchContainer = UIView()
    private var searchBar: SearchBar?
    
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
        
        setupView()
        setupBindings()
        setupSearchBar()
        searchBindings()
    }
    
    private func setupView() {
        view.addSubview(customNavigation)
        customNavigation.layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor)
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
        tableView.registerReusableCell(cellType: GameModesTableViewCell.self)
        tableView.registerReusableHeaderFooterView(viewType: GameModesHeaderView.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 96.0
        tableView.keyboardDismissMode = .onDrag
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
    
    private func setupSearchBar() {
        let searchViewModel = GameModesSearchViewModel()
        searchBar = SearchBar(viewModel: searchViewModel)
        searchContainer.addSubview(searchBar!)
        searchBar?.layout {
            $0.top.equal(to: searchContainer.topAnchor, offsetBy: -1.0)
            $0.leading.equal(to: searchContainer.leadingAnchor, offsetBy: -1.0)
            $0.trailing.equal(to: searchContainer.trailingAnchor, offsetBy: 1.0)
            $0.bottom.equal(to: searchContainer.bottomAnchor, offsetBy: 1.0)
        }
    }
    
    private func searchBindings() {
        if let searchBar = searchBar {
            searchBar.$text.dropFirst().sink { [weak self] searchText in
                self?.model.searchAt(searchText)
            }.store(in: &subscriptions)
            
            searchBar.textDidEndEditing.sink { [ weak self ] _ in
                self?.model.searchDidCancel()
            }.store(in: &subscriptions)
            
        }
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

final class GameModesSearchViewModel: SearchBarViewModelApplicable {
    
    var showsCancelButton: Bool {
        false
    }
    
}
