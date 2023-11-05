//
//  MenuView.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedTab: String = "Issues"
    @Namespace private var namespace
    
    let tabs: [String] = ["Details", "Software", "Issues"]
    var body: some View {
        ZStack {
            VStack {
                title
                header
                Spacer()
                content
                Spacer()
            }
        }
        .background(BackgroundStyle.translucent)
    }
    private var header: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                ZStack(alignment: .bottom) {
                    if tab == selectedTab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.red.opacity(0.8))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                            .frame(width: 80, height: 2)
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
    }
    private var title: some View {
        HStack {
            Text(ProcessInfo.processInfo.hostName)
                .foregroundColor(.appTheme.accent)
                .fontWeight(.bold)
            Spacer()
            HStack {
                if vm.network != nil {
                    if vm.network?.connected ?? false {
                        Circle().frame(width: 5, height: 5)
                            .foregroundColor(.green)
                            .cornerRadius(5)
                        Text("Online")
                            .padding(2)
                    } else {
                        Circle().frame(width: 5, height: 5)
                            .foregroundColor(.red)
                            .cornerRadius(5)
                        Text("Offline")
                            .padding(2)
                    }
                    
                } else {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }
        }
        .padding()
    }
    private var content: some View {
        VStack {
            switch selectedTab {
            case "Details":
                Text("Details")
            case "Software":
                Text("Software")
            case "Issues":
                ScrollView {
                    List {
                        ForEach(vm.issues) { policy in
                            HStack {
                                Image(systemName: "exclamationmark.circle")
                                Text(policy.title)
                                    .lineLimit(1)
                                InfoButton(description: policy.description)
                                Spacer()
                                Button("fix") {
                                }
                            }
                            .padding()
                            .background(.red.opacity(0.8))
                            .cornerRadius(4)
                            .padding(2)
                        }
                    }
                    .listStyle(.inset)
                }
            default:
                Text("Details")
            }
        } 
    }
}

#Preview {
    MenuView()
}
