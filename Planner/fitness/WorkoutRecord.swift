//
//  WorkoutRecord.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import Foundation

struct WorkoutRecord: Identifiable, Codable {
    let id: UUID
    var exerciseName: String
    var weight: Double
    var sets: Int
    var date: Date
    
    init(
        id: UUID = UUID(),
        exerciseName: String,
        weight: Double,
        sets: Int,
        date: Date
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.weight = weight
        self.sets = sets
        self.date = date
    }
}
