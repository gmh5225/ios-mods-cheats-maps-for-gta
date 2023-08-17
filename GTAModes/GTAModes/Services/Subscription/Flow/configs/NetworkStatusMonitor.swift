//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import Network
import UIKit

protocol NetworkStatusMonitorDelegate : AnyObject {
    func showMess()
}

class NetworkStatusMonitor {
    static let shared = NetworkStatusMonitor()

    private let queue = DispatchQueue.global()
    private let nwMonitor: NWPathMonitor
    
    weak var delegate : NetworkStatusMonitorDelegate?

    public private(set) var isNetworkAvailable: Bool = false {
        didSet {
            if !isNetworkAvailable {
                DispatchQueue.main.async {
                    print("No internet connection.")
                    self.delegate?.showMess()
                }
            } else {
                print("Internet connection is active.")
            }
        }
    }

    private init() {
        nwMonitor = NWPathMonitor()
    }

    func startMonitoring() {
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }

    func stopMonitoring() {
        nwMonitor.cancel()
    }
}
