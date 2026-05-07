//
//  CategoryColorManager.swift
//  Planner
//
//  Created by Zhenqiang Chen on 7/5/2026.
//

import SwiftUI

struct CategoryColorManager {
    
    static func color(for categoryName: String) -> Color {
        switch categoryName {
        case "Study":
            return .blue
        case "Fitness":
            return .green
        case "Goals":
            return .orange
        case "Reminder":
            return .purple
        default:
            return automaticColor(for: categoryName)
        }
    }
    
    private static func automaticColor(for name: String) -> Color {
        let colors: [Color] = [
            .pink,
            .teal,
            .indigo,
            .cyan,
            .mint,
            .brown
        ]
        
        let hashValue = abs(name.hashValue)
        let index = hashValue % colors.count
        
        return colors[index]
    }
}
