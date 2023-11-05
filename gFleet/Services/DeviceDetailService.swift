//
//  DeviceService.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import Combine

class DeviceDetailService {
    @Published var deviceDetails: DeviceModel? = nil
    var uptimeSubscription: AnyCancellable?
    var encryptionSubscription: AnyCancellable?
    var deviceSubscription: AnyCancellable?
    
    init() {
        addSubscribers()
    }
    private func addSubscribers() {
        fetchDeviceDetails()
    }
    func fetchDeviceDetails() {
        let sql = """
        SELECT
            (SELECT days FROM uptime) AS uptime,
            (SELECT CASE WHEN COUNT(*) > 0 THEN 'true' ELSE 'false' END
             FROM disk_encryption
             WHERE user_uuid IS NOT '' AND filevault_status = 'on') AS encrypted,
            (SELECT blocks FROM mounts WHERE path = '/') AS totalDiskSpace,
            (SELECT blocks_free FROM mounts WHERE path = '/') AS diskSpace,
            (SELECT physical_memory FROM system_info) AS ramSpace,
            (SELECT version FROM os_version) AS operatingSystem,
            (SELECT arch FROM os_version) AS processorType
        LIMIT 1;
        """
        deviceSubscription = QueryManager.osQuery(sql: sql)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                   print("Error fetching device details: \(error)")
                case .finished:
                   print("Finished fetching device details.")
                }
            }, receiveValue: { [weak self] details in
                do {
                    let data = Data(details.utf8)
                    let devices = try JSONDecoder().decode([DeviceModel].self, from: data)
                    self?.deviceDetails = devices.first
                    self?.deviceSubscription?.cancel()
                } catch {
                    print("Error decoding Configuration: \(error)")
                }
            })
    }
}
