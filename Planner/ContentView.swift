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
            
            CreateTaskView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
        }
    }
}
