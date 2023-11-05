//
//  SoftwareDetailService.swift
//  gFleet
//
//  Created by Eric Rodriguez on 10/1/23.
//

import Foundation
import Combine

class SoftwareDetailService {
    @Published var software: [SoftwareModel] = []
    
    private var softwareSubscription: AnyCancellable?
    
    init() {
        fetchSoftwareDetails()
    }
    
    func fetchSoftwareDetails() {
        let sql = """
            SELECT name, path,
                bundle_executable AS bundleExecutable,
                bundle_identifier AS bundleIdentifier,
                bundle_name AS bundleName,
                bundle_short_version AS bundleShortVersion,
                bundle_version AS bundleVersion,
                display_name AS displayName,
                last_opened_time AS lastOpened
            FROM apps
            LIMIT 200;
        """
        softwareSubscription = QueryManager.osQuery(sql: sql)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching software details: \(error)")
                case .finished:
                    print("Finished fetching software details.")
                }
            }, receiveValue: { [weak self] details in
                do {
                    let data = Data(details.utf8)
                    let softwareDetails = try JSONDecoder().decode([SoftwareModel].self, from: data)
                    self?.software = softwareDetails
                    self?.softwareSubscription?.cancel()
                } catch {
                    print("Error decoding Software: \(error)")
                }
            })
    }
}
