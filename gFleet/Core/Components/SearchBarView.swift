//
//  SearchBarView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 10/1/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeHolder: String = "Search..."
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    text.isEmpty ?
                    Color.appTheme.secondaryText : Color.appTheme.primaryText
                )
            
            TextField(placeHolder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(2)
                .padding(.horizontal, 25)
                .background(Color.appTheme.background)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.appTheme.primaryText)
                        .opacity(text.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            text = ""
                        }
                    
                    ,alignment: .trailing
                )
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.appTheme.background)
                .shadow(radius: 2, x: 2, y: 2)
        )
        .frame(maxWidth: .infinity, maxHeight: 40)
            
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
