//
//  ActionButton.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/30/23.
//

import SwiftUI

struct ActionButton: View {
    @State private var isAnimating: Bool = false
    var systemName: String
    var size: Font = .headline
    var action: () -> Void
      
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 0.5)
                .scaleEffect(isAnimating ? 2 : 0)
                .opacity(isAnimating ? 0 : 1)
                .zIndex(2)
              
            Image(systemName: systemName)
                .font(size)
                .onTapGesture {
                    withAnimation(Animation.easeOut(duration: 0.5)) {
                        self.isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.isAnimating = false
                    }
                    action()
                }
                .onHover { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                .foregroundColor(.appTheme.primaryText)
          }
      }
}

#Preview {
    ActionButton(systemName: "clock", action: {
        
    })
}
