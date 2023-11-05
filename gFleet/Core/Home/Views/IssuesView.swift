//
//  IssuesView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/30/23.
//

import SwiftUI

struct IssuesView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        VStack {
            SearchBarView(text: $vm.issueSearchText, placeHolder: "Search issues...")
                .padding()
            ScrollView {
                LazyVStack {
                    ForEach(vm.issues) { policy in
                        HStack {
                            if policy.status == .unhealthy {
                                Image(systemName: "exclamationmark.circle")
                            }
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
                        .background(policy.status == .healthy ? .blue.opacity(0.8) : .red.opacity(0.8))
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
    IssuesView(vm: DeveloperPreview.instance.homeVM)
}
