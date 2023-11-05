//
//  PolicyModel.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/26/23.
//

import Foundation

enum Status: String, Codable {
    case healthy
    case unhealthy
}

enum RemediationType: String, Codable {
    case automatic
    case manual
    case requiresIT = "requires IT"
}

struct Policy: Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var query: String
    var status: Status = .unhealthy
    var remediationType: RemediationType
    var remediation: String
    var compliantValue: String
    
    enum CodingKeys: String, CodingKey {
            case id, title, description, query, status, remediationType, remediation, compliantValue
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            description = try container.decode(String.self, forKey: .description)
            query = try container.decode(String.self, forKey: .query)
            status = try container.decodeIfPresent(Status.self, forKey: .status) ?? .unhealthy
            remediationType = try container.decode(RemediationType.self, forKey: .remediationType)
            remediation = try container.decode(String.self, forKey: .remediation)
            compliantValue = try container.decode(String.self, forKey: .compliantValue)
        }
}
