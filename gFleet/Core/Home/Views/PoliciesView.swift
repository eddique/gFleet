//
//  DevListView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import SwiftUI

struct PoliciesView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        VStack {
            SearchBarView(text: $vm.policySearchText, placeHolder: "Search policies...")
                .padding()
            ScrollView {
                LazyVStack {
                    ForEach(vm.policies.sorted { ($0.status == .unhealthy) && ($1.status != .unhealthy) } ) { policy in
                        HStack {
                            Image(systemName: policy.status == .healthy ? "checkmark.circle" : "exclamationmark.circle")
                                .padding(0)
                            Text(policy.title)
                            InfoButton(description: policy.description)
                                .onHover { hovering in
                                    if hovering {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            Spacer()
                            Image(systemName: policy.status == .healthy ? "arrow.triangle.2.circlepath" : "exclamationmark.arrow.triangle.2.circlepath")
                                .font(.headline)
                                .padding(0)
                        }
                        .padding()
                        .background(policy.status == .healthy ? Color.appTheme.background.opacity(0.8) : .red.opacity(0.8))
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
    PoliciesView(vm: DeveloperPreview.instance.homeVM)
}
