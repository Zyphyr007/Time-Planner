//
//  FitnessProgressView.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI
import Charts

struct FitnessProgressView: View {
    
    @EnvironmentObject var workoutViewModel: WorkoutRecordViewModel
    
    @State private var exerciseName = ""
    @State private var weightText = ""
    @State private var setsText = ""
    @State private var recordDate = Date()
    @State private var selectedExercise = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    headerSection
                    
                    addRecordSection
                    
                    chartSection
                    
                    historySection
                }
                .padding()
            }
            .navigationTitle("Fitness Progress")
            .onAppear {
                updateSelectedExerciseIfNeeded()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundStyle(.green)
                
                Text("Workout Records")
                    .font(.title2)
                    .bold()
            }
            
            Text("Record exercise weight and sets, then track progress over time.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.green.opacity(0.20),
                    Color.blue.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var addRecordSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Add Workout Record")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Exercise Name")
                    .font(.headline)
                
                TextField("Example: Bench Press", text: $exerciseName)
                    .padding()
                    .background(Color.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weight")
                        .font(.headline)
                    
                    TextField("kg", text: $weightText)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sets")
                        .font(.headline)
                    
                    TextField("sets", text: $setsText)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Date")
                    .font(.headline)
                
                DatePicker(
                    "Record Date",
                    selection: $recordDate,
                    displayedComponents: [.date]
                )
                .padding()
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
            
            Button {
                addWorkoutRecord()
            } label: {
                Text("Save Record")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Progress Chart")
                .font(.title2)
                .bold()
            
            if workoutViewModel.exerciseNames.isEmpty {
                
                Text("No workout records yet.")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
            } else {
                
                Picker("Exercise", selection: $selectedExercise) {
                    ForEach(workoutViewModel.exerciseNames, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                let selectedRecords = workoutViewModel.records(for: selectedExercise)
                
                if selectedRecords.isEmpty {
                    
                    Text("No data available for this exercise.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                } else {
                    
                    Chart(selectedRecords) { record in
                        LineMark(
                            x: .value("Date", record.date),
                            y: .value("Weight", record.weight)
                        )
                        
                        PointMark(
                            x: .value("Date", record.date),
                            y: .value("Weight", record.weight)
                        )
                    }
                    .frame(height: 260)
                    .padding()
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Text("This chart shows the weight progression for \(selectedExercise).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Workout History")
                .font(.title2)
                .bold()
            
            if workoutViewModel.records.isEmpty {
                
                Text("No history available.")
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
            } else {
                
                ForEach(workoutViewModel.records.sorted { $0.date > $1.date }) { record in
                    workoutRecordRow(record)
                }
            }
        }
    }
    
    private func workoutRecordRow(_ record: WorkoutRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(record.exerciseName)
                    .font(.headline)
                
                Text("\(record.weight, specifier: "%.1f") kg • \(record.sets) sets")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(dateText(record.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(role: .destructive) {
                workoutViewModel.deleteRecord(record)
                updateSelectedExerciseIfNeeded()
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func addWorkoutRecord() {
        errorMessage = ""
        successMessage = ""
        
        let trimmedExerciseName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedExerciseName.isEmpty else {
            errorMessage = "Please enter an exercise name."
            return
        }
        
        guard let weight = Double(weightText), weight > 0 else {
            errorMessage = "Please enter a valid weight."
            return
        }
        
        guard let sets = Int(setsText), sets > 0 else {
            errorMessage = "Please enter a valid number of sets."
            return
        }
        
        workoutViewModel.addRecord(
            exerciseName: trimmedExerciseName,
            weight: weight,
            sets: sets,
            date: recordDate
        )
        
        selectedExercise = trimmedExerciseName
        
        exerciseName = ""
        weightText = ""
        setsText = ""
        recordDate = Date()
        successMessage = "Workout record saved successfully."
    }
    
    private func updateSelectedExerciseIfNeeded() {
        if selectedExercise.isEmpty || !workoutViewModel.exerciseNames.contains(selectedExercise) {
            selectedExercise = workoutViewModel.exerciseNames.first ?? ""
        }
    }
    
    private func dateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
