
import UIKit
import Combine

class GTA_GameModesViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GTAModes_GameModesModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let customNavigation: GTAModes_CustomNavigationView
    private let searchContainer = UIView()
    private var searchBar: GTAModes_SearchBar?
    
    var alert: UIAlertController?
    
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
        // super
        super.viewDidLoad()
        
        // some comment
        gta_setupView()
        // some comment
        gta_setupBindings()
        // some comment
        gta_setupSearchBar()
        // some comment
        gta_searchBindings()
        // some comment
    }
    
    private func gta_setupView() {
        view.addSubview(customNavigation)
        customNavigation.gta_layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor, offsetBy: 21.0)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        
        view.addSubview(searchContainer)
        searchContainer.gta_layout {
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 16.0)
            $0.leading.equal(to: view.safeAreaLayoutGuide.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.safeAreaLayoutGuide.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 42)
        }
        searchContainer.backgroundColor = UIColor(named: "checkCellBlue")?.withAlphaComponent(0.4)
        searchContainer.withCornerRadius(20.0)
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.gta_layout {
            $0.top.equal(to: searchContainer.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
        }
        tableView.registerReusableCell(cellType: GTAModes_GameModesTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 496.0 : 296.0
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func gta_setupBindings() {
        model.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }.store(in: &subscriptions)
        
        model.showSpinnerData.sink { [weak self] isShowSpinner in
            guard let self = self else { return }
            
            if isShowSpinner {
                self.gta_showSpiner()
            } else {
                self.gta_hideAlert()
            }
        }.store(in: &subscriptions)
        
    }
    
    private func gta_setupSearchBar() {
        let searchViewModel = GameModesSearchViewModel()
        searchBar = GTAModes_SearchBar(viewModel: searchViewModel)
        searchContainer.addSubview(searchBar!)
        searchBar?.gta_layout {
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
    
    private func gta_showSpiner() {
        alert = UIAlertController(title: nil, message: "Download Mode", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alert?.view.addSubview(loadingIndicator)
        
        present(alert!, animated: true, completion: nil)
        
    }
    
    private func gta_hideAlert() {
        alert?.dismiss(animated: false)
    }
    
    func gta_shareFile(at mode: ModItem) {
        if model.gta_checkIsLoadData(mode.title) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(mode.title)
            
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        } else {
            gta_showTextAlert("To share, you must first download")
        }
    }
    
    
    func gta_showTextAlert(_ text: String) {
        alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(alert!, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.gta_hideAlert()
            
        }
    }
    
    
}

extension GTA_GameModesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_GameModesTableViewCell = tableView.dequeueReusableCell(indexPath)
        let mode = model.modeItems[indexPath.row]
        cell.gameMode_configure_cell(mode, isLoaded: model.gta_checkIsLoadData(mode.title))
        cell.backgroundColor = .clear
        
        cell.downloadAction = { [weak self] in
            if GTA_NetworkStatusMonitor.shared.isNetworkAvailable {
                self?.model.gta_downloadMode(index: indexPath.row)
            } else {
                self?.gta_showTextAlert("No internet")
            }
        }
        
        cell.shareAction = { [weak self] in
            self?.gta_shareFile(at: mode)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.modeItems.count
    }
    
}

final class GameModesSearchViewModel: GTAModes_SearchBarViewModelApplicable {
    
    var showsCancelButton: Bool {
        false
    }
    
}
