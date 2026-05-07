//
//  DashboardView.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: PlannerViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Life Planner")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Organise your university life.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    // Highlight card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.title2)
                            
                            Text("Today's Overview")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                        }
                        
                        Text("You have \(viewModel.itemsForToday().count) task(s) scheduled today.")
                            .font(.headline)
                        
                        Text("Check your timetable and stay on track.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.25),
                                Color.purple.opacity(0.18)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(radius: 6)
                    
                    // Category Cards
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 14
                    ) {
                        ForEach(viewModel.categories) { category in
                            SummaryCard(
                                title: category.name,
                                count: viewModel.todayCount(for: category.name),
                                icon: category.icon,
                                color: CategoryColorManager.color(for: category.name)
                            )
                        }
                    }
                    
                    // Today's Tasks
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Today's Tasks")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            Image(systemName: "checklist")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        
                        if viewModel.itemsForToday().isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "tray")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                
                                Text("No tasks scheduled today.")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            ForEach(viewModel.itemsForToday()) { item in
                                PlannerRow(item: item)
                                    .padding()
                                    .background(
                                        CategoryColorManager
                                            .color(for: item.categoryName)
                                            .opacity(0.12)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(radius: 2)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct SummaryCard: View {
    
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
                
                Text("\(count)")
                    .font(.title)
                    .bold()
            }
            
            Text(title)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    color.opacity(0.25),
                    color.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
    }
}
