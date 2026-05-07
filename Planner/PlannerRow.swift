//
//  PlannerRow.swift
//  Planner
//
//  Created by Zixuan Liuyang on 7/5/2026.
//

import SwiftUI

struct PlannerRow: View {
    
    @EnvironmentObject var viewModel: PlannerViewModel
    
    let item: PlannerItem
    
    var body: some View {
        HStack {
            Button {
                viewModel.toggleCompletion(item)
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .strikethrough(item.isCompleted)
                
                Text("\(item.categoryName) • \(item.priority.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(timeText(item.startTime)) - \(timeText(item.endTime))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                viewModel.deleteItem(item)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func timeText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
