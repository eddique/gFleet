//
//  MenuBarIcon.swift
//  gFleet
//
//  Created by Eric Rodriguez on 10/1/23.
//

import SwiftUI

struct MenuBarIcon: View {
    let image: NSImage = {
            let ratio = $0.size.height / $0.size.width
            $0.size.height = 12
            $0.size.width = 12 / ratio
            return $0
        }(NSImage(named: "Logo")!)
    
    var body: some View {
        Image(nsImage: image)
    }
}

#Preview {
    MenuBarIcon()
}
