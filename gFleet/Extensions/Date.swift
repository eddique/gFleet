//
//  Date.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/28/23.
//

import Foundation

extension Date {

    func timestampFormatter() -> String {
        let timeInterval = Date().timeIntervalSince(self)
        if timeInterval < 3600 { // less than 1 hour
            let minutes = Int(timeInterval / 60)
            if minutes < 1 {
                return "just now"
            }
            return minutes == 1 ? "\(minutes) minute ago" : "\(minutes) minutes ago"
        } else if timeInterval < 86400 { // between 1 hour and 24 hours
            let hours = Int(timeInterval / 3600)
            return hours == 1 ? "\(hours) hour ago" : "\(hours) hours ago"
        } else { // more than 24 hours
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy hh:mm a"
            return formatter.string(from: self)
        }
    }
}
