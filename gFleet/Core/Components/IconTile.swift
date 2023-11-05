//
//  IconTile.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/30/23.
//

import SwiftUI

struct IconTile: View {
    var systemName: String
    var colors: [Color]
    var cornerRadius: CGFloat = 4
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing
    var size: CGFloat = 40
    var padding: CGFloat = 8
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
                    )
            )
    }
}

#Preview {
    IconTile(systemName: "clock", colors: [.red, .blue])
}
