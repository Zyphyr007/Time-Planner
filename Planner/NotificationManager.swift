//
//  NotificationManager.swift
//  Life-Planner
//
//  Created by Haoming Chen on 7/5/2026.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { success, error in
            
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            
            print("Notification permission success: \(success)")
        }
    }
    
    func scheduleReminder(title: String, body: String, date: Date) {
        
        guard date > Date() else {
            print("Reminder date must be in the future.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            } else {
                print("Reminder scheduled successfully.")
            }
        }
    }
}
