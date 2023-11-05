//
//  NetworkDetailService.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import Combine

class NetworkDetailService {
    @Published var networkModel: NetworkModel = NetworkModel(networkName: nil, connected: nil)
    var networkSubscription: AnyCancellable?

    init() {
        fetchNetworkDetails()
    }
    func fetchNetworkDetails() {
        fetchNetworkData()
        checkInternetConnection()
    }
    private func fetchNetworkData() {
        let sql = "SELECT (SELECT network_name FROM wifi_status) AS networkName;"
        networkSubscription = QueryManager.osQuery(sql: sql)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching network details: \(error)")
                case .finished:
                    print("Finished fetching network details.")
                }
            }, receiveValue: { [weak self] details in
                do {
                    let data = Data(details.utf8)
                    let networks = try JSONDecoder().decode([NetworkModel].self, from: data)
                    self?.networkModel.networkName = networks.first?.networkName
                    self?.networkSubscription?.cancel()
                } catch {
                    print("Error decoding NetworkModel: \(error)")
                }
            })
    }
    private func checkInternetConnection() {
        self.networkModel.connected = nil
        isConnectedToInternet { isConnected in
            DispatchQueue.main.async {
                self.networkModel.connected = isConnected
            }
        }
    }
    private func isConnectedToInternet(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/sbin/ping")
            process.arguments = ["-c", "1", "8.8.8.8"]
            process.standardOutput = nil

            do {
                try process.run()
                process.waitUntilExit()
                let isConnected = process.terminationStatus == 0
                DispatchQueue.main.async {
                    completion(isConnected)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
