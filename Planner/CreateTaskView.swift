//
//  Untitled.swift
//  Planner
//
//  Created by Zixuan Liuyang on 7/5/2026.
//

import SwiftUI

struct CreateTaskView: View {
    
    @EnvironmentObject var viewModel: PlannerViewModel
    
    @State private var title = ""
    @State private var selectedCategoryName = "Study"
    @State private var customCategoryName = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var priority: Priority = .medium
    @State private var useCustomCategory = false
    
    private let defaultCategoryNames = [
        "Study",
        "Fitness",
        "Goals",
        "Reminder"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Task Information") {
                    TextField("Task Title", text: $title)
                    
                    Toggle("Use Custom Category", isOn: $useCustomCategory)
                    
                    if useCustomCategory {
                        TextField("New Category Name", text: $customCategoryName)
                    } else {
                        Picker("Category", selection: $selectedCategoryName) {
                            ForEach(viewModel.categories, id: \.name) { category in
                                Text(category.name)
                                    .tag(category.name)
                            }
                        }
                    }
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue)
                                .tag(priority)
                        }
                    }
                }
                
                Section("Schedule") {
                    DatePicker(
                        "Start Time",
                        selection: $startTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    DatePicker(
                        "End Time",
                        selection: $endTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                Section {
                    Button("Create Task") {
                        createTask()
                    }
                }
                
                Section("Manage Categories") {
                    ForEach(viewModel.categories, id: \.name) { category in
                        HStack {
                            Text(category.name)
                            
                            Spacer()
                            
                            if !defaultCategoryNames.contains(category.name) {
                                Button(role: .destructive) {
                                    viewModel.deleteCategory(category)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Create Task")
        }
    }
    
    private func createTask() {
        let finalCategoryName: String
        
        if useCustomCategory {
            let trimmedCategory = customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedCategory.isEmpty else {
                return
            }
            
            viewModel.addCategory(name: trimmedCategory)
            finalCategoryName = trimmedCategory
        } else {
            finalCategoryName = selectedCategoryName
        }
        
        viewModel.addItem(
            title: title,
            categoryName: finalCategoryName,
            startTime: startTime,
            endTime: endTime,
            priority: priority
        )
        
        title = ""
        customCategoryName = ""
        selectedCategoryName = viewModel.categories.first?.name ?? "Study"
        priority = .medium
        useCustomCategory = false
    }
}
