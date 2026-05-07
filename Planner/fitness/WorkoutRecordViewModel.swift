//
//  Untitled.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import Foundation
import SwiftUI
import Combine

class WorkoutRecordViewModel: ObservableObject {
    
    @Published var records: [WorkoutRecord] = [] {
        didSet {
            saveRecords()
        }
    }
    
    private let saveKey = "workoutRecords"
    
    init() {
        loadRecords()
        
        if records.isEmpty {
            addSampleData()
        }
    }
    
    var exerciseNames: [String] {
        let names = records.map { $0.exerciseName }
        return Array(Set(names)).sorted()
    }
    
    func addRecord(
        exerciseName: String,
        weight: Double,
        sets: Int,
        date: Date
    ) {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        guard weight > 0 else {
            return
        }
        
        guard sets > 0 else {
            return
        }
        
        let newRecord = WorkoutRecord(
            exerciseName: trimmedName,
            weight: weight,
            sets: sets,
            date: date
        )
        
        records.append(newRecord)
    }
    
    func deleteRecord(_ record: WorkoutRecord) {
        records.removeAll { $0.id == record.id }
    }
    
    func records(for exerciseName: String) -> [WorkoutRecord] {
        records
            .filter { $0.exerciseName == exerciseName }
            .sorted { $0.date < $1.date }
    }
    
    private func saveRecords() {
        do {
            let data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Failed to save workout records: \(error.localizedDescription)")
        }
    }
    
    private func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            return
        }
        
        do {
            records = try JSONDecoder().decode([WorkoutRecord].self, from: data)
        } catch {
            print("Failed to load workout records: \(error.localizedDescription)")
        }
    }
    
    private func addSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        let day1 = calendar.date(byAdding: .day, value: -14, to: today) ?? today
        let day2 = calendar.date(byAdding: .day, value: -10, to: today) ?? today
        let day3 = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        let day4 = calendar.date(byAdding: .day, value: -2, to: today) ?? today
        
        records = [
            WorkoutRecord(
                exerciseName: "Bench Press",
                weight: 40,
                sets: 3,
                date: day1
            ),
            WorkoutRecord(
                exerciseName: "Bench Press",
                weight: 42.5,
                sets: 3,
                date: day2
            ),
            WorkoutRecord(
                exerciseName: "Bench Press",
                weight: 45,
                sets: 4,
                date: day3
            ),
            WorkoutRecord(
                exerciseName: "Bench Press",
                weight: 47.5,
                sets: 4,
                date: day4
            ),
            WorkoutRecord(
                exerciseName: "Squat",
                weight: 50,
                sets: 3,
                date: day1
            ),
            WorkoutRecord(
                exerciseName: "Squat",
                weight: 55,
                sets: 3,
                date: day2
            ),
            WorkoutRecord(
                exerciseName: "Squat",
                weight: 60,
                sets: 4,
                date: day3
            ),
            WorkoutRecord(
                exerciseName: "Deadlift",
                weight: 60,
                sets: 3,
                date: day1
            ),
            WorkoutRecord(
                exerciseName: "Deadlift",
                weight: 65,
                sets: 3,
                date: day3
            )
        ]
    }
}
