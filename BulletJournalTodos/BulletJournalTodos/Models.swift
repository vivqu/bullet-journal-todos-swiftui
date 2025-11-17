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
final class Task: Identifiable {
    var id: UUID
    var text: String
    var isComplete: Bool
    var focusArea: FocusArea
    var sortOrder: Int
    var createdAt: Date
    var week: Week?

    init(text: String, isComplete: Bool = false, focusArea: FocusArea, sortOrder: Int) {
        self.id = UUID()
        self.text = text
        self.isComplete = isComplete
        self.focusArea = focusArea
        self.sortOrder = sortOrder
        self.createdAt = Date()
        // week must be set after task is inserted into modelContext
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
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Force Monday as week start regardless of locale
        let now = Date()

        // Get the Monday of the current week
        guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            assertionFailure("⚠️ Developer Warning: Calendar failed to compute Monday from date components. This should never happen with valid Calendar/Date.")
            return calendar.startOfDay(for: now)
        }

        return calendar.startOfDay(for: monday)
    }
}
