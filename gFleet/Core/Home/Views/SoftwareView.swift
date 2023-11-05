//
//  SoftwareView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/26/23.
//

import SwiftUI

struct SoftwareView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        VStack {
            SearchBarView(text: $vm.softwareSearchText, placeHolder: "Search software...")
                .padding()
            ScrollView {
                LazyVStack {
                    ForEach(vm.software) { software in
                        HStack {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(.appTheme.primaryText)
                            Text(software.displayName)
                            Text(software.path)
                                .lineLimit(1)
                            Spacer()
                            InfoButton(description: software.bundleVersion)
                        }
                        .padding()
                        .background(Color.appTheme.background)
                        .cornerRadius(4)
                        .padding(2)
                    }
                }
                .listStyle(.inset)
            }
            .padding()
        }
    }
}

#Preview {
    SoftwareView(vm: DeveloperPreview.instance.homeVM)
}
