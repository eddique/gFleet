//
//  PreviewProvider.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() {}
    
    let homeVM = HomeViewModel()
}
