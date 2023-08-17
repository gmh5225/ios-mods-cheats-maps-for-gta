//
//  Reachability.swift
//  GTAModes
//
//  Created by Максим Педько on 16.08.2023.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

/// The `Reachability` class listens for reachability changes of hosts and addresses for both WWAN and
/// WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed, or to retry
/// network requests when a connection is established. It should not be used to prevent a user from initiating a network
/// request, as it's possible that an initial request may be required to establish reachability.
final public class GTAModes_Reachability {
    
    /// Defines the various states of network reachability.
    ///
    /// - unknown:      It is unknown whether the network is reachable.
    /// - notReachable: The network is not reachable.
    /// - reachable:    The network is reachable.
    public enum NetworkReachabilityStatus {
        case notReachable
        case reachable(ConnectionType, String?)
        case unknown
    }
    
    /// Defines the various connection types detected by reachability flags.
    ///
    /// - wifi: The connection type is WiFi.
    /// - wwan: The connection type is a WWAN connection.
    public enum ConnectionType: Int, RawRepresentable {
        case notReachable = 1
        case wifi = 2
        case wwan = 4
        case both = 8
        case unknown = 16
    }
    
    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias Listener = (NetworkReachabilityStatus) -> Void
    
    // MARK: - Properties
    
    /// Whether the network is currently reachable.
    public var isReachable: Bool { return isReachableOnWWAN || isReachableOnWiFi ||
        networkReachabilityStatus != .notReachable }
    
    /// Whether the network is currently reachable over the WWAN interface.
    public var isReachableOnWWAN: Bool { return networkReachabilityStatus == .reachable(.wwan, getSSID()) }
    
    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    public var isReachableOnWiFi: Bool { return networkReachabilityStatus == .reachable(.wifi, getSSID()) }
    
    /// The current network reachability status.
    public var networkReachabilityStatus: NetworkReachabilityStatus {
        guard let flags = self.flags else { return .unknown }
        
        return networkReachabilityStatusForFlags(flags)
    }
    
    /// The dispatch queue to execute the `listener` closure on.
    public var listenerQueue: DispatchQueue = DispatchQueue.main
    
    /// A closure executed when the network reachability status changes.
    public var listener: Listener?
    
    public var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else { return nil }
        
        return flags
    }
    
    /// Handler for general level network events
    private let generalNetworkEventHandler: SCNetworkReachabilityCallBack = { (_, flags, info) in
        if let info = info {
            let reachability = Unmanaged<GTAModes_Reachability>.fromOpaque(info).takeUnretainedValue()
            reachability.gta_notifyListener(flags)
        }
    }
    
    /// Handler for system level network events
    private let systemNetworkEventHandler: CFNotificationCallback = { center, observer, name, object, info in
        if let observer = observer {
            let unmanagedSelf = Unmanaged<GTAModes_Reachability>.fromOpaque(observer).takeUnretainedValue()
            unmanagedSelf.gta_notifyListener(unmanagedSelf.flags ?? SCNetworkReachabilityFlags())
        }
    }
    
    private let reachability: SCNetworkReachability
    public var previousFlags: SCNetworkReachabilityFlags
    public var previousSSID: String?
    
    // MARK: - Initialization
    
    /// Creates a `Reachability` instance with the specified host.
    ///
    /// - parameter host: The host used to evaluate network reachability.
    ///
    /// - returns: The new `Reachability` instance.
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        self.init(reachability: reachability)
    }
    
    /// Creates a `Reachability` instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    ///
    /// - returns: The new `Reachability` instance.
    public convenience init?() {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &address, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return nil }
        
        self.init(reachability: reachability)
    }
    
    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
        self.previousFlags = SCNetworkReachabilityFlags()
        self.previousSSID = getSSID()
    }
    
    deinit {
        gta_stopListening()
    }
    
    // MARK: - Listening
    
    /// Starts listening for changes in network reachability status.
    ///
    /// - returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    public func gta_startListening() -> Bool {
        var context = SCNetworkReachabilityContext(
            version: 0,
            info: nil,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        context.info = Unmanaged.passUnretained(self).toOpaque()
        
        let callbackEnabled = SCNetworkReachabilitySetCallback(reachability,
                                                               generalNetworkEventHandler,
                                                               &context)
        
        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        Unmanaged.passUnretained(self).toOpaque(),
                                        systemNetworkEventHandler,
                                        "com.apple.system.config.network_change" as CFString,
                                        nil,
                                        .deliverImmediately)
        
        return callbackEnabled && queueEnabled
    }
    
    /// Stops listening for changes in network reachability status.
    public func gta_stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                           Unmanaged.passUnretained(self).toOpaque(),
                                           CFNotificationName("com.apple.system.config.network_change" as CFString),
                                           nil)
    }
    
    /// Pings provided server address.
    /// Make sure to disable 'App Trsnsport Security' if you are trying to ping non-secure URL.
    /// Protocol prefix should be added manually (http://, etc.)
    /// - parameter host: The host used to ping.
    ///
    /// - returns: boolean value indicating when ping was successfull and response status code/error description.
    public func ping(_ fullURL: String, completionHandler: @escaping ((Bool, String) -> Void)) {
        guard let url = URL(string: fullURL) else { completionHandler(false, "Wrong URL."); return }
        
        let pingTask = URLSession.shared.dataTask(with: url) { _, response, error in
            if error == nil, let httpResponse = response as? HTTPURLResponse {
                completionHandler(true, String(httpResponse.statusCode))
            } else {
                completionHandler(false, error?.localizedDescription ?? "")
            }
        }
        
        pingTask.resume()
    }
    
    // MARK: - Internal - Listener Notification
    
    func gta_notifyListener(_ flags: SCNetworkReachabilityFlags) {
        let ssid = getSSID()
        
        guard previousFlags != flags
            || (previousSSID != nil && ssid != nil && previousSSID != ssid ) else { return }
        
        previousFlags = flags
        previousSSID = ssid
        
        listener?(networkReachabilityStatusForFlags(flags))
    }
    
    // MARK: - Internal - Network Reachability Status
    
    func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> NetworkReachabilityStatus {
        guard isNetworkReachable(with: flags) else { return .notReachable }
        
        let ssid = getSSID()
        var networkStatus: NetworkReachabilityStatus = .unknown
        if flags.contains(.reachable) && !flags.contains(.isWWAN) {
            networkStatus = .reachable(.both, ssid)
            return networkStatus
        }
        if flags.contains(.isWWAN) {
            networkStatus = .reachable(.wwan, ssid)
            return networkStatus
        }
        
        return networkStatus
    }
    
    func getSSID() -> String? {
        guard let interfacesArray = CNCopySupportedInterfaces() as? [String], !interfacesArray.isEmpty else {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil { return nil }
        
        guard let interfaceData = unsafeInterfaceData as? [String: AnyObject] else { return nil }
        let ssid = interfaceData[kCNNetworkInfoKeySSID as String] as? String
        
        return ssid
    }
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}

// MARK: - Extensions

extension GTAModes_Reachability.NetworkReachabilityStatus: Equatable {}

/// Returns whether the two network reachability status values are equal.
///
/// - parameter lhs: The left-hand side value to compare.
/// - parameter rhs: The right-hand side value to compare.
///
/// - returns: `true` if the two values are equal, `false` otherwise.
public func == (lhs: GTAModes_Reachability.NetworkReachabilityStatus, rhs: GTAModes_Reachability.NetworkReachabilityStatus) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
        
    case (.notReachable, .notReachable):
        return true
        
    case let (.reachable(lhsConnectionType, lhsConnectionName), .reachable(rhsConnectionType, rhsConnectionName)):
        return (lhsConnectionType == rhsConnectionType) && (lhsConnectionName == rhsConnectionName)
        
    default:
        return false
        
    }
}
