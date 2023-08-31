
import UIKit
import Combine

class GTA_GameModesViewController: GTAModes_NiblessViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GTAModes_GameModesModel
    private let tableView = UITableView(frame: .zero)
    private let customNavigation: GTAModes_CustomNavigationView
    private let searchContainer = UIView()
    private var searchBar: GTAModes_SearchBar?
    
    var activityVC: UIActivityViewController?
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 2. set its sourceRect here. It's the same as in step 4
            activityVC?.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        }
    }
    
    
    override func viewDidLoad() {
        // super
        super.viewDidLoad()
        
        if model.modeItems.isEmpty {
            gta_showLoadSpiner()
        }
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
    
    func gta_showLoadSpiner() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        alert = UIAlertController(title: nil, message: "Loading Data", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alert?.view.addSubview(loadingIndicator)
        
        present(alert!, animated: true, completion: nil)
    }
    
    
    private func gta_hideSpiner() {
        alert?.dismiss(animated: false)
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
            $0.top.equal(to: searchContainer.bottomAnchor, offsetBy: 20.0)
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
        
        model.showDocumentSaverData.sink { [weak self] localUrl in
            guard let self = self else { return }
            
            print(localUrl)
            self.presentDocumentsPickerForExport(urlPath: localUrl)
            
            
            
        }.store(in: &subscriptions)
        
        model.showAlertSaverData.sink { [weak self] textAlert in
            guard let self = self else { return }
            
            self.gta_showTextAlert(textAlert)
            
            
            
        }.store(in: &subscriptions)
        
        model.hideSpiner = { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
            self.gta_hideSpiner()
        }
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
        alert = UIAlertController(title: nil, message: "Downloading mode", preferredStyle: .alert)
        
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
        if model.gta_checkIsLoadData(mode.modPath) {
            
            if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(mode.modPath) {
                do {
                    activityVC = nil
                    activityVC = UIActivityViewController(
                        activityItems: [fileURL],
                        applicationActivities: nil
                    )
                    activityVC?.popoverPresentationController?.sourceView = self.view
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        activityVC?.modalPresentationStyle = .overFullScreen
                    }
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        activityVC?.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                        activityVC?.popoverPresentationController?.permittedArrowDirections = []
                    }
                    
                    present(activityVC!, animated: true, completion: nil)
                    
                    activityVC?.completionWithItemsHandler = { [weak self] (
                        activityType,
                        completed: Bool,
                        returnedItems: [Any]?,
                        error: Error?
                    ) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.activityVC = nil
                        }
                    }
                } catch {
                    gta_showTextAlert("Error creating sharable URL: \(error)")
                    //                    print("Error creating sharable URL: \(error)")
                }
            }
        } else {
            gta_showTextAlert("To share, you must first download it")
        }
    }
    
    
    func gta_showTextAlert(_ text: String) {
        alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(alert!, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.gta_hideAlert()
            
        }
    }
    
//    func gta_showAlertAge() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.addAction(
//            UIAlertAction(
//                title: L10n.ChatAction.save,
//                style: .default,
//                handler: { [weak self] _ in
//                    self?.model.saveImageToLibrary()
//                }
//            )
//        )
//        alertController.addAction(
//            UIAlertAction(
//                title: L10n.ChatAction.forward,
//                style: .default,
//                handler: { [weak self] _ in
//                    self?.model.forward()
//                }
//            )
//        )
//        alertController.addAction(UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel, handler: nil))
//
//        present(alertController, animated: true, completion: nil)
//
//    }
    
    
}

extension GTA_GameModesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_GameModesTableViewCell = tableView.dequeueReusableCell(indexPath)
        let mode = model.modeItems[indexPath.row]
        cell.gameMode_configure_cell(mode, isLoaded: model.gta_checkIsLoadData(mode.modPath))
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

extension GTA_GameModesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension GTA_GameModesViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func presentDocumentsPickerForExport(urlPath: String) {
        
        if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(urlPath) {
            DispatchQueue.main.async { [weak self] in
                do {
                    let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL], asCopy: true)
                    documentPicker.delegate = self
                    documentPicker.shouldShowFileExtensions = true
                    self?.present(documentPicker, animated: true, completion: nil)
                } catch {
                    self?.gta_showTextAlert("ERROR")
                }
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("File exported successfully to Files app.")
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled by the user.")
    }
    
}
