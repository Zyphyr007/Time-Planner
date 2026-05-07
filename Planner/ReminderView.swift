//
//  ReminderView.swift
//  Planner
//
//  Created by Zicheng Mei on 7/5/2026.
//

import SwiftUI

struct ReminderView: View {
    @State private var reminderTitle = ""
    @State private var reminderDate = Date()
    @State private var message = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Create Reminder") {
                    TextField("Reminder title", text: $reminderTitle)

                    DatePicker(
                        "Reminder Time",
                        selection: $reminderDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    Button("Set Reminder") {
                        setReminder()
                    }
                }

                if !message.isEmpty {
                    Section("Status") {
                        Text(message)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Reminder")
            .onAppear {
                NotificationManager.shared.requestPermission()
            }
        }
    }

    private func setReminder() {
        let trimmedTitle = reminderTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            message = "Please enter a reminder title."
            return
        }

        guard reminderDate > Date() else {
            message = "Please select a future time."
            return
        }

        NotificationManager.shared.scheduleReminder(
            title: "Life Planner Reminder",
            body: trimmedTitle,
            date: reminderDate
        )

        message = "Reminder has been set."
        reminderTitle = ""
    }
}
