//
//  PlannerViewModel.swift
//  Planner
//
//  Created by Zicheng Mei on 7/5/2026.
//

import Foundation
import SwiftUI
import Combine

class PlannerViewModel: ObservableObject {
    
    @Published var items: [PlannerItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var categories: [PlannerCategory] = PlannerCategory.defaultCategories {
        didSet {
            saveCategories()
        }
    }
    
    private let itemsSaveKey = "lifePlannerItems"
    private let categoriesSaveKey = "lifePlannerCategories"
    
    init() {
        loadCategories()
        loadItems()
        
        if items.isEmpty {
            addSampleData()
        }
    }
    
    func addCategory(name: String, icon: String = "folder.fill") {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        let alreadyExists = categories.contains {
            $0.name.lowercased() == trimmedName.lowercased()
        }
        
        guard !alreadyExists else {
            return
        }
        
        let newCategory = PlannerCategory(
            name: trimmedName,
            icon: icon
        )
        
        categories.append(newCategory)
    }
    
    func deleteCategory(_ category: PlannerCategory) {
        let defaultNames = [
            "Study",
            "Fitness",
            "Goals",
            "Reminder"
        ]
        
        if defaultNames.contains(category.name) {
            return
        }
        
        categories.removeAll {
            $0.name == category.name
        }
        
        items.removeAll {
            $0.categoryName == category.name
        }
    }
    
    func addItem(
        title: String,
        categoryName: String,
        startTime: Date,
        endTime: Date,
        priority: Priority
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            return
        }
        
        guard endTime > startTime else {
            return
        }
        
        let newItem = PlannerItem(
            title: trimmedTitle,
            categoryName: categoryName,
            startTime: startTime,
            endTime: endTime,
            priority: priority
        )
        
        items.append(newItem)
    }
    
    func deleteItem(_ item: PlannerItem) {
        items.removeAll {
            $0.id == item.id
        }
    }
    
    func toggleCompletion(_ item: PlannerItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        items[index].isCompleted.toggle()
    }
    
    func items(for categoryName: String) -> [PlannerItem] {
        return items.filter {
            $0.categoryName == categoryName
        }
    }
    
    func itemsForToday() -> [PlannerItem] {
        return items
            .filter {
                Calendar.current.isDateInToday($0.startTime)
            }
            .sorted {
                $0.startTime < $1.startTime
            }
    }
    
    func todayCount(for categoryName: String) -> Int {
        return itemsForToday().filter {
            $0.categoryName == categoryName
        }.count
    }
    
    var completedCount: Int {
        return items.filter {
            $0.isCompleted
        }.count
    }
    
    var totalCount: Int {
        return items.count
    }
    
    var completionRate: Double {
        guard totalCount > 0 else {
            return 0
        }
        
        return Double(completedCount) / Double(totalCount)
    }
    
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: itemsSaveKey)
        } catch {
            print("Failed to save items: \(error.localizedDescription)")
        }
    }
    
    private func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsSaveKey) else {
            return
        }
        
        do {
            items = try JSONDecoder().decode([PlannerItem].self, from: data)
        } catch {
            print("Failed to load items: \(error.localizedDescription)")
        }
    }
    
    private func saveCategories() {
        do {
            let data = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(data, forKey: categoriesSaveKey)
        } catch {
            print("Failed to save categories: \(error.localizedDescription)")
        }
    }
    
    private func loadCategories() {
        guard let data = UserDefaults.standard.data(forKey: categoriesSaveKey) else {
            return
        }
        
        do {
            categories = try JSONDecoder().decode([PlannerCategory].self, from: data)
        } catch {
            print("Failed to load categories: \(error.localizedDescription)")
        }
    }
    
    private func addSampleData() {
        let now = Date()
        let calendar = Calendar.current
        
        let studyStart = calendar.date(
            bySettingHour: 9,
            minute: 0,
            second: 0,
            of: now
        ) ?? now
        
        let studyEnd = calendar.date(
            bySettingHour: 10,
            minute: 30,
            second: 0,
            of: now
        ) ?? now
        
        let fitnessStart = calendar.date(
            bySettingHour: 17,
            minute: 0,
            second: 0,
            of: now
        ) ?? now
        
        let fitnessEnd = calendar.date(
            bySettingHour: 18,
            minute: 0,
            second: 0,
            of: now
        ) ?? now
        
        items = [
            PlannerItem(
                title: "Finish SwiftUI assignment",
                categoryName: "Study",
                startTime: studyStart,
                endTime: studyEnd,
                priority: .high
            ),
            PlannerItem(
                title: "30 minutes cardio",
                categoryName: "Fitness",
                startTime: fitnessStart,
                endTime: fitnessEnd,
                priority: .medium
            )
        ]
    }
}
