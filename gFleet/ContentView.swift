//
//  ContentView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: HomeViewModel
    var body: some View {
        NavigationSplitView{
            navigationLinks
        } detail: {
            DisplayView {
                HomeView()
            }
        }
    }
    private var navigationLinks: some View {
        VStack {
            List {
                NavigationLink {
                    DisplayView {
                        HomeView()
                    }
                    
                } label: {
                    HStack {
                        IconTile(systemName: "gauge.medium", colors: [.teal], size: 16, padding: 2)
                        Text("Dashboard")
                    }
                }
                NavigationLink {
                    DisplayView {
                        DetailsView()
                    }
                    
                } label: {
                    HStack {
                        IconTile(systemName: "laptopcomputer", colors: [.purple], size: 16, padding: 2)
                        Text("Device")
                    }
                }
                NavigationLink {
                    DisplayView {
                        SoftwareView(vm: vm)
                    }
                } label: {
                    HStack {
                        IconTile(systemName: "square.stack.3d.down.right", colors: [.orange], size: 16, padding: 2)
                        Text("Software")
                    }
                }
                NavigationLink {
                    DisplayView {
                        PoliciesView(vm: vm)
                    }
                } label: {
                    HStack {
                        IconTile(systemName: "doc.plaintext", colors: [.blue], size: 16, padding: 2)
                        Text("Policies")
                    }
                }
                NavigationLink {
                    DisplayView {
                        IssuesView(vm: vm)
                    }
                } label: {
                    HStack {
                        IconTile(systemName: "exclamationmark.circle", colors: [.red], size: 16, padding: 2)
                        Text("Issues")
                    }
                    .badge(vm.issues.count)
                }
            }
            .listStyle(.sidebar)
        }
        .frame(minWidth: 200)
    }
}

#Preview {
    ContentView()
}
