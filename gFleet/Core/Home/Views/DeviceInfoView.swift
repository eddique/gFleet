//
//  DeviceInfoView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/30/23.
//

import SwiftUI

struct DeviceInfoView: View {
    @StateObject var vm: HomeViewModel
    @Binding var selectedTab: String
    var body: some View {
        HStack {
            VStack {
                Text("Status")
                    .font(.callout)
                    .fontWeight(.bold)
                HStack {
                    if vm.network != nil {
                        if vm.network?.connected ?? false {
                            Circle().frame(width: 5, height: 5)
                                .foregroundColor(.green)
                                .cornerRadius(5)
                            Text("Healthy")
                                
                        } else {
                            Circle().frame(width: 5, height: 5)
                                .foregroundColor(.red)
                                .cornerRadius(5)
                            Text("Unhealthy")
                                
                        }
                        
                    } else {
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                }
                .padding(0)
                Text("Issues")
                    .font(.callout)
                    .fontWeight(.bold)
                HStack {
                    if vm.issues.count > 0 {
                        Image(systemName: "exclamationmark.circle")
                            
                        Text("\(vm.issues.count)")
                            .padding(2)
                            .textSelection(.disabled)
                    } else {
                        Text("0")
                            .padding(2)
                    }
                    
                }
                .onTapGesture {
                    withAnimation {
                        selectedTab = "Issues"
                    }
                }
                .onHover{ hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .padding()
            VStack {
                Text("Disk space")
                    .font(.callout)
                    .fontWeight(.bold)
                Text("\(vm.deviceDetails?.diskSpaceInGB ?? "-") GB available")
                    .padding(2)
                Text("Memory")
                    .font(.callout)
                    .fontWeight(.bold)
                Text("\(vm.deviceDetails?.totalRamSpaceInGB ?? "-") GB")
                    .padding(2)
            }
            .padding()
            VStack {
                Text("Processor type")
                    .font(.callout)
                    .fontWeight(.bold)
                Text("\(vm.deviceDetails?.processorType ?? "-")")
                    .padding(2)
                Text("Operating system")
                    .font(.callout)
                    .fontWeight(.bold)
                Text("\(vm.deviceDetails?.operatingSystem ?? "-")")
                    .padding(2)
            }
            .padding()
            VStack {
                Text("Device uptime")
                    .font(.callout)
                    .fontWeight(.bold)
                Text("\(vm.deviceDetails?.uptime ?? "-") \(vm.deviceDetails?.uptime == "1" ? "day" : "days")")
                    .padding(2)
                Text("Filevault enabled")
                    .font(.callout)
                    .fontWeight(.bold)
                if vm.deviceDetails?.encrypted ?? "false" == "true" {
                    Image(systemName: "checkmark.seal")
                        .foregroundColor(.blue)
                        .padding(2)
                } else {
                    Image(systemName: "xmark.seal")
                        .foregroundColor(.red)
                        .padding(2)
                }
            }
            .padding()
            VStack {
                Text("Network connection")
                    .font(.callout)
                    .fontWeight(.bold)
                HStack {
                    if vm.network != nil {
                        if vm.network?.connected ?? false {
                            Circle().frame(width: 5, height: 5)
                                .foregroundColor(.green)
                                .cornerRadius(5)
                            Text("Online")
                                
                        } else {
                            Circle().frame(width: 5, height: 5)
                                .foregroundColor(.red)
                                .cornerRadius(5)
                            Text("Offline")
                                
                        }
                        
                    } else {
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                }
                .padding(0)
                Text("Network name")
                    .font(.callout)
                    .fontWeight(.bold)
                Text(vm.network?.networkName ?? "-")
                    .padding(2)
            }
            .padding()
        }
        .textSelection(.enabled)
        .padding(4)
        .background(Color.appTheme.secondaryBackground)
        .foregroundColor(.appTheme.primaryText)
        .cornerRadius(10)
        .shadow(radius: 2, x: 2, y: 2)
    }
}

#Preview {
    DeviceInfoView(vm: DeveloperPreview.instance.homeVM, selectedTab: .constant("Issues"))
}
