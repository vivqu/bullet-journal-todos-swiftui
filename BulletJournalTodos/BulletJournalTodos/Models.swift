//
//  Models.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/11/25.
//

import Foundation
import SwiftData

enum FocusArea: String, Codable {
    case life
    case work
}

@Model
final class Task {
    var text: String
    var isComplete: Bool
    var focusArea: FocusArea
    var sortOrder: Int
    var createdAt: Date
    var week: Week

    init(text: String, isComplete: Bool = false, focusArea: FocusArea, sortOrder: Int, week: Week) {
        self.text = text
        self.isComplete = isComplete
        self.focusArea = focusArea
        self.sortOrder = sortOrder
        self.createdAt = Date()
        self.week = week

        // Validate that the week matches the current week
        let currentWeekStart = Week.getCurrentWeekStart()
        if week.startDate != currentWeekStart {
            assertionFailure("⚠️ Developer Warning: Task created with week starting \(week.startDate), but current week starts \(currentWeekStart). Tasks should be created in the current week.")
        }
    }
}

@Model
final class Week {
    var startDate: Date
    @Relationship(deleteRule: .cascade, inverse: \Task.week)
    var tasks: [Task]

    init(startDate: Date, tasks: [Task] = []) {
        self.startDate = startDate
        self.tasks = tasks
    }

    /// Returns the start date (Monday at 00:00:00) of the current week
    static func getCurrentWeekStart() -> Date {
        let calendar = Calendar.current
        let now = Date()

        // Get the Monday of the current week
        guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return calendar.startOfDay(for: now)
        }

        return calendar.startOfDay(for: monday)
    }
}
