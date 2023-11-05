//
//  DisplayView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 10/1/23.
//

import SwiftUI

struct DisplayView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
           self.content = content()
       }
    var body: some View {
        ZStack {
            titleBar
            content
                .frame(minWidth: 800, minHeight: 700, maxHeight: .infinity)
        }
    }
    private var titleBar: some View {
        VStack {
            HStack(spacing: 2) {
                Image("Logo")
                    .resizable()
                    .frame(width: 20, height: 14)
                    .foregroundColor(.appTheme.accent)
                Text("gFleet")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.appTheme.accent)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(BackgroundStyle.translucent)
            .ignoresSafeArea()
            Spacer()
        }
    }
}

#Preview {
    DisplayView {
        
    }
}
