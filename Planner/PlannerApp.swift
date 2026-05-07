//
//  PlannerApp.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI

@main
struct PlannerApp: App {
    
    @StateObject private var plannerViewModel = PlannerViewModel()
    
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plannerViewModel)
        }
    }
}
