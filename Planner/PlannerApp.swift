//
//  PlannerApp.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI

@main
struct Life_PlannerApp: App {
    
    @StateObject private var plannerViewModel = PlannerViewModel()
    @StateObject private var workoutRecordViewModel = WorkoutRecordViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plannerViewModel)
                .environmentObject(workoutRecordViewModel)
        }
    }
}
