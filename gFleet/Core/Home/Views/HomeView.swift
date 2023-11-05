//
//  HomeView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedTab: String = "Details"
    @Namespace private var namespace
    
    let tabs: [String] = ["Details", "Software", "Policies", "Issues"]
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    header
                    deviceInfo
                    tabView
                }
                .padding()
                .background(Color.appTheme.background)
                .cornerRadius(12)
                .padding()
                .shadow(radius: 2, x: 2, y: 2)
                Spacer()
                content
            }
            .padding()
        }
        .background(BackgroundStyle.translucent)
    }
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    IconTile(systemName: "lock.laptopcomputer", colors: [Color.indigo, .appTheme.accent])
                    VStack(alignment: .leading) {
                        Text(ProcessInfo.processInfo.hostName)
                            .font(.title)
                            .foregroundColor(.appTheme.primaryText)
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.appTheme.primaryText)
                            Text("Last modified \(vm.lastChecked.timestampFormatter())")
                                .font(.caption)
                                .frame(alignment: .bottom)
                                .foregroundColor(.appTheme.primaryText)
                        }
                    }
                }
                .padding(.bottom)
            }
            .textSelection(.enabled)
            Spacer()
            ReloadButton {
                vm.refetchDetails()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    private var tabView: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                ZStack(alignment: .bottom) {
                    if tab == selectedTab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.red.opacity(0.8))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                            .frame(width: 120, height: 2)
                            .offset(y: 10)
                    }
                    HStack {
                        if tab == "Issues" && vm.issues.count > 0 {
                            ZStack {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 16, height: 16)

                                Text("\(vm.issues.count)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 10))
                            }
                            .frame(minHeight: 0)
                        }
                        Text(tab)
                            .foregroundColor(tab == selectedTab ? .appTheme.accent : .appTheme.primaryText)
                            .fontWeight(tab == selectedTab ? .semibold : .regular)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onHover(perform: { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                })
                .onTapGesture {
                    withAnimation {
                        selectedTab = tab
                    }
                    
                }
                
            }
            
        }
        .padding()
    }
    private var deviceInfo: some View {
        DeviceInfoView(vm: vm, selectedTab: $selectedTab)
    }
    private var content: some View {
        VStack {
            switch selectedTab {
            case "Details":
                DetailsView()
            case "Software":
                SoftwareView(vm: vm)
            case "Policies":
                PoliciesView(vm: vm)
            case "Issues":
                IssuesView(vm: vm)
            default:
                Text("Details")
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(DeveloperPreview.instance.homeVM)
}
