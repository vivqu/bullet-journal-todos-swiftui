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
    var week: Week?

    init(text: String, isComplete: Bool = false, focusArea: FocusArea, sortOrder: Int, week: Week? = nil) {
        self.text = text
        self.isComplete = isComplete
        self.focusArea = focusArea
        self.sortOrder = sortOrder
        self.week = week
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
}
