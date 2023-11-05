//
//  gFleetApp.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import SwiftUI

@main
struct gFleetApp: App {
    @StateObject private var vm = HomeViewModel()
    
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(vm)
            .onAppear {
                NotificationManager.instance.requestAuthorization()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 700, height: 550)

        MenuBarExtra {
            MenuView()
                .environmentObject(vm)
        } label: {
            MenuBarIcon()
                .onReceive(timer) { _ in
                    vm.refetchDetails()
                    print("polling device details")
                }
        }
        .menuBarExtraStyle(.window)

    }
}
