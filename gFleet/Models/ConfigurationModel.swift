//
//  Configuration.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/26/23.
//

import Foundation

struct Configuration: Codable {
    var organization: String
    var policies: [Policy]
}
