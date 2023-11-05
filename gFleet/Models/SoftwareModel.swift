//
//  SoftwareModel.swift
//  gFleet
//
//  Created by Eric Rodriguez on 10/1/23.
//

import Foundation

struct SoftwareModel: Codable, Identifiable {
    var name: String
    var path: String
    var bundleExecutable: String
    var bundleIdentifier: String
    var bundleName: String
    var bundleShortVersion: String
    var bundleVersion: String
    var displayName: String
    var lastOpened: String
    
    var id: String {
        self.path
    }
}
