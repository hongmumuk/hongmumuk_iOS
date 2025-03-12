//
//  NetworkManager.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/12/25.
//

import Combine
import Network

final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")

    @Published var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        
        monitor.start(queue: queue)
    }
}
