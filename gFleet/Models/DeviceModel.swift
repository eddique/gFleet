//
//  DeviceModel.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/26/23.
//

import Foundation

struct DeviceModel: Codable {
    var uptime: String
    var diskSpace: String
    var totalDiskSpace: String
    var ramSpace: String
    var encrypted: String
    var operatingSystem: String
    var processorType: String
    var diskSpaceInGB: String {
        let diskSpaceDouble = Double(Int(diskSpace) ?? 0) * 4096 / pow(1024, 3)
        return String(Int(diskSpaceDouble))
    }
    var totalDiskSpaceInGB: String {
        let totalDiskSpaceDouble = Double(Int(totalDiskSpace) ?? 0) * 4096 / pow(1024, 3)
        return String(Int(totalDiskSpaceDouble))
    }
    var totalRamSpaceInGB: String {
        let ramSpaceDouble = Double(Int(ramSpace) ?? 0) / pow(1024, 3)
        return String(Int(ramSpaceDouble))
    }
}
