//
//  ConfigurationDetailService.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/27/23.
//

import Foundation
import Combine
class ConfigurationDetailService {
    @Published var configuration: Configuration? = nil
    
    var subscription: AnyCancellable?
    
    init() {
        addSubscribers()
    }
    private func addSubscribers() {
        loadConfiguration()
    }
    func loadConfiguration() {
        subscription = ConfigurationManager.shared.loadConfiguration()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("error fetching configuration: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] config in
                self?.configuration = config
                self?.checkPolicies()
                self?.subscription?.cancel()
            })
    }
    func checkPolicies() {
        guard var configuration = configuration else {
            print("No configuration loaded.")
            return
        }

        for (index, policy) in configuration.policies.enumerated() {
            let sql = "SELECT (\(policy.query)) AS value;"
            QueryManager.osQuerySQL(sql: sql) { result in
                switch result {
                case .success(let outputString):
                    do {
                        print("DATA: \(outputString)")
                        let data = Data(outputString.utf8)
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        print("JSON: \(String(describing: json))")
                        if let keyValue = json?.first?["value"] as? String, keyValue == policy.compliantValue {
                            DispatchQueue.main.async {
                                print("POLICY HEALTHY")
                                configuration.policies[index].status = .healthy
                                self.configuration = configuration
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("POLICY UNHEALTHY")
                                configuration.policies[index].status = .unhealthy
                                self.configuration = configuration
                            }
                        }
                    } catch {
                        print("Error decoding policy: \(error)")
                    }
                case .failure(let error):
                    print("Error checking policy: \(error)")
                }
            }
        }
    }
    func remediatePolicies() {
        let issues = self.configuration?.policies.filter { $0.status == .unhealthy } ?? []
        issues.forEach { policy in
            switch policy.remediationType {
            case .automatic:
                print("running automatic remediation")
            case .manual:
                print("manual remediation needed.")
            case .requiresIT:
                print("remediation requires IT")
            }
        }
    }
}
