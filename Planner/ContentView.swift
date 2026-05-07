//
//  ContentView.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            TimetableView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Timetable")
                }
            
            FitnessProgressView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Fitness")
                }
            
            CreateTaskView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
        }
    }
}
