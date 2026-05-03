//
//  NetworkMonitor.swift
//  Omar Fazal
//
//  Created by silenGSR on 13/02/26.
//

import Foundation
import Network
import Observation

protocol NetworkMonitoring {
    var isConnected: Bool { get }
}

enum NetworkQuality {
    case offLine
    case unknown
    case low
    case good
    case high
}

/// Note:
/// NWPathMonitor works perfect in physical device and simulator with the exception that in simulator you can not "play" to switch turn on/off the Wi-Fi internet in Mac becouse simulator works diferent becouse of the virtual conection (and could have wrong states). So to check changes availabity on real-time please Check/Confirm at physical device

@Observable
final class NWPathNetworkMonitor: NetworkMonitoring {
    
    static let shared = NWPathNetworkMonitor()
    
    private var monitor: NWPathMonitor?
    fileprivate let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private(set) var isRunning: Bool = false
    private(set) var quality: NetworkQuality = .unknown
    
    private(set) var isConnected: Bool = false
    
    private init() {
        startObserving()
    }
    
    func startObserving() {
        guard !isRunning else { return }
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            
            Task { @MainActor in
                
                guard let self else { return }
                
                self.isConnected = (path.status == .satisfied)
                
                if self.isConnected == false {
                    self.quality = .offLine
                    return
                }
                
                if #available(iOS 26.0, *) {
                    switch path.linkQuality {
                        
                    case .unknown:
                        self.quality = .unknown
                    case .minimal:
                        self.quality = .low
                    case .moderate:
                        self.quality = .good
                    case .good:
                        self.quality = .high
                    @unknown default:
                        self.quality = .unknown
                    }
                } else {
                    
                    if path.isConstrained {
                        self.quality = .low
                    }
                    else if path.isExpensive {
                        self.quality = .good // 4g/5g so.. could not be good
                    }
                    else {
                        self.quality = .high // wifi, same thing could not be good
                    }
                }
            }
        }
        
        self.monitor = monitor
        self.isRunning = true
        monitor.start(queue: queue)
    }
    
    nonisolated func stopObserving() {
        Task { @MainActor [weak self] in
            self?.monitor?.cancel()
            self?.monitor = nil
            self?.isRunning = false
        }
    }
    
    deinit {
        stopObserving()
    }
}

