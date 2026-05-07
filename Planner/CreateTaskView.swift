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
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    private let defaultNames = ["Study", "Fitness", "Goals", "Reminder"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    
                    headerCard
                    
                    taskTitleSection
                    
                    categorySection
                    
                    prioritySection
                    
                    scheduleSection
                    
                    messageSection
                    
                    createButton
                    
                    manageCategoriesSection
                }
                .padding()
            }
            .navigationTitle("Create Task")
        }
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                Text("Plan a New Activity")
                    .font(.title2)
                    .bold()
            }
            
            Text("Create a study, fitness, goal, reminder, or custom task and place it into your daily timetable.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.18),
                    Color.purple.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var taskTitleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Task Title")
                .font(.headline)
            
            TextField("Example: SwiftUI Assignment", text: $title)
                .padding()
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    
                    ForEach(viewModel.categories) { category in
                        categoryButton(
                            title: category.name,
                            icon: category.icon,
                            color: CategoryColorManager.color(for: category.name)
                        ) {
                            selectedCategoryName = category.name
                            useCustomCategory = false
                        }
                    }
                    
                    categoryButton(
                        title: "Custom",
                        icon: "plus",
                        color: .gray
                    ) {
                        useCustomCategory = true
                    }
                }
            }
            
            if useCustomCategory {
                TextField("New Category Name", text: $customCategoryName)
                    .padding()
                    .background(Color.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
    
    private func categoryButton(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        
        let isSelected = useCustomCategory ? title == "Custom" : selectedCategoryName == title
        
        return Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? .white : color)
            .frame(width: 90, height: 76)
            .background(isSelected ? color : color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
    
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority")
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(Priority.allCases) { item in
                    Button {
                        priority = item
                    } label: {
                        Text(item.rawValue)
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(priority == item ? priorityColor(item) : Color.gray.opacity(0.12))
                            .foregroundStyle(priority == item ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)
            
            VStack(spacing: 12) {
                DatePicker(
                    "Start Time",
                    selection: $startTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .padding()
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                DatePicker(
                    "End Time",
                    selection: $endTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .padding()
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
    
    private var messageSection: some View {
        VStack {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .font(.subheadline)
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var createButton: some View {
        Button {
            createTask()
        } label: {
            Text("Create Task")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
    
    private var manageCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manage Categories")
                .font(.headline)
            
            VStack(spacing: 10) {
                ForEach(viewModel.categories) { category in
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundStyle(CategoryColorManager.color(for: category.name))
                            .frame(width: 28)
                        
                        Text(category.name)
                        
                        Spacer()
                        
                        if !defaultNames.contains(category.name) {
                            Button(role: .destructive) {
                                viewModel.deleteCategory(category)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }
    
    private func createTask() {
        errorMessage = ""
        successMessage = ""
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Please enter a task title."
            return
        }
        
        guard endTime > startTime else {
            errorMessage = "End time must be later than start time."
            return
        }
        
        let finalCategoryName: String
        
        if useCustomCategory {
            let trimmedCategory = customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedCategory.isEmpty else {
                errorMessage = "Please enter a custom category name."
                return
            }
            
            viewModel.addCategory(name: trimmedCategory)
            finalCategoryName = trimmedCategory
        } else {
            finalCategoryName = selectedCategoryName
        }
        
        viewModel.addItem(
            title: trimmedTitle,
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
        startTime = Date()
        endTime = Date().addingTimeInterval(3600)
        successMessage = "Task created successfully."
    }
    
    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}
