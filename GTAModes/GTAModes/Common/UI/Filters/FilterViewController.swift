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

private extension CGFloat {
    
    static let panIndicatorTopOffset = 16.0
    static let tableViewTopOffset = 16.0
    static let tableViewBottomOffset = 100.0
    static let headerHeight = 16.0
    
    static var totalVerticalOffsets: CGFloat {
        panIndicatorTopOffset + tableViewTopOffset + tableViewBottomOffset + headerHeight
    }
    
}

public class PanDragIndicator: NiblessView {
    
    public static let height = 4.0
    
    public override init() {
        super.init()
        
        setupView()
    }
    
    private func setupView() {
        withCornerRadius(Self.height / 2.0)
        layout {
            $0.width.equal(to: 32.0)
            $0.height.equal(to: PanDragIndicator.height)
        }
        
        backgroundColor = .gray
    }
}

protocol FilterNavigationHandler: AnyObject {
    
    func filterDidRequestToClose()
}

final class FilterViewController: NiblessFilterViewController {
    
    private let filterData: [FilterData]
    private let tableView = UITableView(frame: .zero)
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let navigationHandler: FilterNavigationHandler
    
    public init(filterData: [FilterData], navigationHandler: FilterNavigationHandler) {
        self.filterData = filterData
        self.navigationHandler = navigationHandler
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.withCornerRadius()
        titleLabel.text = "Filter"
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.layout {
            $0.centerX.equal(to: view.centerXAnchor)
            $0.top.equal(to: view.topAnchor, offsetBy: 24.0)
        }
        
        view.addSubview(closeButton)
        closeButton.layout {
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.centerY.equal(to: titleLabel.centerYAnchor)
            $0.height.equal(to: 24.0)
            $0.width.equal(to: 24.0)
        }
        closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        tableView.accessibilityIdentifier = "tableView"
        view.addSubview(tableView)
        tableView.layout {
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.top.equal(to: titleLabel.bottomAnchor)
            $0.bottom.equal(to: view.safeAreaLayoutGuide.bottomAnchor, priority: .defaultLow)
        }
        tableView.backgroundColor = .black
        tableView.isScrollEnabled = false
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 70.0
        tableView.registerReusableCell(cellType: FilterTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
    }
    
    @objc
    func closeAction() {
        navigationHandler.filterDidRequestToClose()
    }
    
}

extension FilterViewController: PanPresentable {
    
    private var contentSize: CGSize {
        CGSize(
            width: view.frame.width,
            height: 500.0
        )
    }
    
    func minContentHeight(presentingController: UIViewController) -> CGFloat {
        contentSize.height
    }
    
    func maxContentHeight(presentingController: UIViewController) -> CGFloat {
        contentSize.height
    }
    
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCell(indexPath)
        let valueCell = filterData[indexPath.row]
        cell.configure(valueCell)
        cell.backgroundColor = .black
        
        return cell
    }
    
}
