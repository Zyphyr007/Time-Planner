//
//  TimetableView.swift
//  Life-Planner
//
//  Created by Haoming Chen on 7/5/2026.
//

import SwiftUI

struct TimetableView: View {
    
    @EnvironmentObject var viewModel: PlannerViewModel
    
    private let hours = Array(6...23)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    
                    HStack {
                        Text("Time")
                            .frame(width: 70)
                            .font(.headline)
                        
                        Text("Today's Timetable")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    
                    ForEach(hours, id: \.self) { hour in
                        HStack(alignment: .top, spacing: 0) {
                            
                            Text(String(format: "%02d:00", hour))
                                .frame(width: 70, height: 70)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                let items = itemsForHour(hour)
                                
                                if items.isEmpty {
                                    Text("")
                                        .frame(height: 60)
                                } else {
                                    ForEach(items) { item in
                                        timetableCard(item)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 70, alignment: .topLeading)
                            .padding(.horizontal, 8)
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color.gray.opacity(0.25)),
                            alignment: .bottom
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Timetable")
        }
    }
    
    private func itemsForHour(_ hour: Int) -> [PlannerItem] {
        viewModel.itemsForToday().filter { item in
            let startHour = Calendar.current.component(.hour, from: item.startTime)
            let endHour = Calendar.current.component(.hour, from: item.endTime)
            
            return hour >= startHour && hour <= endHour
        }
    }
    
    private func timetableCard(_ item: PlannerItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(item.title)
                .font(.headline)
                .strikethrough(item.isCompleted)
            
            Text("\(timeText(item.startTime)) - \(timeText(item.endTime))")
                .font(.caption)
            
            Text(item.categoryName)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.white.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(item.isCompleted ? 0.1 : 0.25))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func timeText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
