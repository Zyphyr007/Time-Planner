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
                VStack(spacing: 20) {
                    
                    VStack(spacing: 8) {
                        Text("Life Planner")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Today's Overview")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 12
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Today's Tasks")
                            .font(.title2)
                            .bold()
                        
                        if viewModel.itemsForToday().isEmpty {
                            
                            Text("No tasks scheduled today.")
                                .foregroundStyle(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                        } else {
                            
                            ForEach(viewModel.itemsForToday()) { item in
                                PlannerRow(item: item)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
        VStack(spacing: 10) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
            
            Text("\(count)")
                .font(.title)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
