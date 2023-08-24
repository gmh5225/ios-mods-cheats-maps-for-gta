//
//  GTA_NetworkStatusMonitor.swift
//  GTAModes
//
//  Created by Максим Педько on 24.08.2023.
//

import Foundation
import Network
import UIKit

class GTA_NetworkStatusMonitor {
    static let shared = GTA_NetworkStatusMonitor()

    private let queue = DispatchQueue.global()
    
    
    weak var delegate : GTA_NetworkStatusMonitorDelegate?
    
    private let nwMonitor: NWPathMonitor

    public private(set) var isNetworkAvailable: Bool = false {
        didSet {
            if !isNetworkAvailable {
                DispatchQueue.main.async {
                    print("No internet connection.")
                    self.delegate?.gta_showMess()
                }
            } else {
                print("Internet connection is active.")
            }
        }
    }

    func gta_startMonitoring() {
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }
    
    private init() {
        nwMonitor = NWPathMonitor()
    }

    func gta_stopMonitoring() {
        nwMonitor.cancel()
    }
}

protocol GTA_NetworkStatusMonitorDelegate : AnyObject {
    func gta_showMess()
}

