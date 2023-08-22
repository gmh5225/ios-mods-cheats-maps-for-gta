//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import Network
import UIKit

protocol GTA_NetworkStatusMonitorDelegate : AnyObject {
    func gta_showMess()
}

class GTA_NetworkStatusMonitor {
    static let shared = GTA_NetworkStatusMonitor()

    private let queue = DispatchQueue.global()
    private let nwMonitor: NWPathMonitor
    
    weak var delegate : GTA_NetworkStatusMonitorDelegate?

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

    private init() {
        nwMonitor = NWPathMonitor()
    }

    func gta_startMonitoring() {
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }

    func gta_stopMonitoring() {
        nwMonitor.cancel()
    }
}
