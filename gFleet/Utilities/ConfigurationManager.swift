//
//  ConfigurationManager.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/27/23.
//

import Foundation
import Combine

class ConfigurationManager {
    static let shared = ConfigurationManager()
    func loadConfiguration() -> AnyPublisher<Configuration, Error> {
        loadJSONConfiguration()
            .catch{ _ in
                self.loadPListConfiguration()}
            .eraseToAnyPublisher()
    }
    private func loadPListConfiguration() -> AnyPublisher<Configuration, Error> {
        return Future<Configuration, Error> { promise in
            DispatchQueue.global().async {
                guard let plistPath = Bundle.main.path(forResource: "gfleet-config", ofType: "plist") else {
                    promise(.failure(NSError(domain: "ConfigurationManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find 'gfleet-config.plist' in app bundle."])))
                    return
                }
                let url = URL(fileURLWithPath: plistPath)
                guard let data = try? Data(contentsOf: url) else {
                    promise(.failure(NSError(domain: "ConfigurationManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not load 'gfleet-config.plist' from app bundle."])))
                    return
                }
                
                do {
                    let configuration = try PropertyListDecoder().decode(Configuration.self, from: data)
                    promise(.success(configuration))
                } catch {
                    promise(.failure(NSError(domain: "ConfigurationManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse 'gfleet-config.plist' as a Configuration."])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    private func loadJSONConfiguration() -> AnyPublisher<Configuration, Error> {
        return Future<Configuration, Error> { promise in
            DispatchQueue.global().async {
                guard let jsonPath = Bundle.main.path(forResource: "gfleet-config", ofType: "json") else {
                    promise(.failure(NSError(domain: "QueryManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find 'gfleet-config.json' in app bundle."])))
                    return
                }
                let url = URL(fileURLWithPath: jsonPath)
                guard let data = try? Data(contentsOf: url) else {
                    promise(.failure(NSError(domain: "QueryManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not load 'gfleet-config.json' from app bundle."])))
                    return
                }
                do {
                    let configuration = try JSONDecoder().decode(Configuration.self, from: data)
                    promise(.success(configuration))
                } catch {
                    promise(.failure(NSError(domain: "QueryManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse 'gfleet-config.json' as a Configuration."])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
