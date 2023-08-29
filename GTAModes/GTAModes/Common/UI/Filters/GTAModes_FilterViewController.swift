//
//  FilterViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation
import UIKit

public struct FilterData {
    
    public let title: String
    public let isCheck: Bool
    
}

public class PanDragIndicator: GTAModes_NiblessView {
    
    public static let height = 4.0
    
    public override init() {
        super.init()
        
        gta_setupView()
    }
    
    private func gta_setupView() {
        withCornerRadius(Self.height / 2.0)
        gta_layout {
            $0.width.equal(to: 32.0)
            $0.height.equal(to: PanDragIndicator.height)
        }
        
        backgroundColor = .gray
    }
}

protocol FilterNavigationHandler: AnyObject {
    
    func filterDidRequestToClose()
}

final class GTAModes_FilterViewController: NiblessFilterViewController {
    
    public var selectedFilter: (String) -> ()
    private let filterListData: FilterListData
    private let tableView = UITableView(frame: .zero)
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let navigationHandler: FilterNavigationHandler
    private var selectedValue: String
    
    
    public init(
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> (),
        navigationHandler: FilterNavigationHandler
    ) {
        self.filterListData = filterListData
        self.selectedFilter = selectedFilter
        self.selectedValue = filterListData.selectedItem
        self.navigationHandler = navigationHandler
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        gta_setupView()
    }
    
    private func gta_setupView() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        view.withCornerRadius()
        titleLabel.text = "Filter"
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.gta_layout {
            $0.centerX.equal(to: view.centerXAnchor)
            $0.top.equal(to: view.topAnchor, offsetBy: 24.0)
        }
        
        view.addSubview(closeButton)
        closeButton.gta_layout {
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.centerY.equal(to: titleLabel.centerYAnchor)
            $0.height.equal(to: 24.0)
            $0.width.equal(to: 24.0)
        }
        closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(gta_closeAction), for: .touchUpInside)
        
        tableView.accessibilityIdentifier = "tableView"
        view.addSubview(tableView)
        tableView.gta_layout {
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.top.equal(to: titleLabel.bottomAnchor)
            $0.bottom.equal(to: view.safeAreaLayoutGuide.bottomAnchor, priority: .defaultLow)
        }
        tableView.backgroundColor = .black
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 70.0
        tableView.registerReusableCell(cellType: GTAModes_FilterTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc
    func gta_closeAction() {
        navigationHandler.filterDidRequestToClose()
    }
    
}

extension GTAModes_FilterViewController: PanPresentable {
    
    private var contentSize: CGSize {
        CGSize(
            width: view.frame.width,
            height: 500.0
        )
    }
    
    func minContentHeight(presentingController: UIViewController) -> CGFloat {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return contentSize.height
    }
    
    func maxContentHeight(presentingController: UIViewController) -> CGFloat {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return contentSize.height
    }
    
}

extension GTAModes_FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return filterListData.filterList.count
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GTAModes_FilterTableViewCell = tableView.dequeueReusableCell(indexPath)
        let titleCell = filterListData.filterList[indexPath.row]
        let filterDataCell = FilterData(title: titleCell, isCheck: isCheckFilter(titleCell) )
        cell.gta_configure_cell(filterDataCell)
        cell.backgroundColor = .black
        
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        return cell
    }
    
    private func isCheckFilter(_ titleCell: String) -> Bool {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        if titleCell == filterListData.selectedItem, titleCell == selectedValue {
            return true
        }
        
        if titleCell == filterListData.selectedItem, titleCell != selectedValue {
            return false
        }
        
        if titleCell != filterListData.selectedItem, titleCell == selectedValue {
            return true
        }
        
        return false
    }
    
}

extension GTAModes_FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedValue == filterListData.filterList[indexPath.row] {
            selectedValue = ""
            selectedFilter("")
        } else {
            selectedValue = filterListData.filterList[indexPath.row]
            selectedFilter(selectedValue)
        }
        tableView.reloadData()
    }
}
