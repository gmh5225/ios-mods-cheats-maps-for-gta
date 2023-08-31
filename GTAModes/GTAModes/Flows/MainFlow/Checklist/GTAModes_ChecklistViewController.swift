
import UIKit
import Combine

class GTAModes_ChecklistViewController: GTAModes_NiblessViewController {
    
    var alert: UIAlertController?
    
    private var subscriptions = Set<AnyCancellable>()
    private let model: GTAModes_ChecklistModel
    private let tableView = UITableView(frame: .zero)
    private let customNavigation: GTAModes_CustomNavigationView
    
    init(model: GTAModes_ChecklistModel) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        self.model = model
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        self.customNavigation = GTAModes_CustomNavigationView(.checkList)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        super.init()
        
        customNavigation.leftButtonAction = { [weak self] in
            self?.model.gta_backActionProceed()
        }
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        customNavigation.rightButtonAction = { [weak self] in
            self?.model.gta_filterActionProceed()
        }
        //
    }
    
    private func gta_setupBindings() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        model.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }.store(in: &subscriptions)
        
        model.hideSpiner = { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
            self.gta_hideSpiner()
        }
        
    }
    
    private func gta_showSpiner() {
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
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        //
        
        if model.missionList.isEmpty {
            gta_showSpiner()
        }
        gta_setupView()
        //
        gta_setupBindings()
    }
    
    private func gta_setupView() {
        view.addSubview(customNavigation)
        customNavigation.gta_layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor, offsetBy: 21.0)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.gta_layout {
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 40.0)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
        }
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        tableView.registerReusableCell(cellType: GTAModes_ChecklistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82.0
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

extension GTAModes_ChecklistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_ChecklistCell = tableView.dequeueReusableCell(indexPath)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        cell.gta_configure_cell(model.missionList[indexPath.row])
        cell.backgroundColor = .clear
        
        cell.isCheckAction = { [weak self] isCheck in
            guard let self = self else { return }
            
            self.model.gta_missionIsCheck(indexPath.row, isCheck: isCheck)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
       return model.missionList.count
        //
        //
    }
    
}

