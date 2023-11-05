//
//  InfoButton.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/30/23.
//

import SwiftUI

struct InfoButton: View {
    @State private var showPopover: Bool = false
    var description: String
    let size: Font = .headline
    
    var body: some View {
        Image(systemName: "info.circle")
            .font(size)
            .onTapGesture {
                self.showPopover = true
            }
            .popover(isPresented: $showPopover, arrowEdge: .top) {
                Text(description)
                   .padding()
                   .frame(maxWidth: 200)
            }
    }
}

#Preview {
    InfoButton(description: "Policy description")
}
