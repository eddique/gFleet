//
//  ReloadButton.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/28/23.
//

import SwiftUI

struct ReloadButton: View {
    @State private var rotation: Double = 0
    var size: Font = .headline
    var action: () -> Void
      
    var body: some View {
        ActionButton(systemName: "arrow.clockwise") {
            withAnimation(.spring()) {
                self.rotation += 360
            }
            action()
        }
        .rotationEffect(Angle(degrees: rotation))
      }
  }

#Preview {
    ReloadButton(action: {
        
    })
}
