//
//  PlannerItem.swift
//  Planner
//
//  Created by Zixuan Liuyang on 7/5/2026.
//

import Foundation

struct PlannerCategory: Identifiable, Codable, Hashable {
    var id: String { name }
    var name: String
    var icon: String
    
    static let defaultCategories: [PlannerCategory] = [
        PlannerCategory(name: "Study", icon: "book.fill"),
        PlannerCategory(name: "Fitness", icon: "figure.run"),
        PlannerCategory(name: "Goals", icon: "checkmark.circle.fill"),
        PlannerCategory(name: "Reminder", icon: "bell.fill")
    ]
}

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String {
        rawValue
    }
}

struct PlannerItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var categoryName: String
    var startTime: Date
    var endTime: Date
    var priority: Priority
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        categoryName: String,
        startTime: Date,
        endTime: Date,
        priority: Priority,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.categoryName = categoryName
        self.startTime = startTime
        self.endTime = endTime
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
