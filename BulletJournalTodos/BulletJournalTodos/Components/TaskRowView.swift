//
//  TaskRowView.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/26/25.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: Task

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: {
                task.isComplete.toggle()
            }) {
                Image(systemName: task.isComplete ? "checkmark.square" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)

            // Task text
            Text(task.text)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview Data

#Preview("Incomplete Task") {
    let week = Week(startDate: Week.getCurrentWeekStart())
    let task = Task(text: "Example todo 1", isComplete: false, focusArea: .life, sortOrder: 0, week: week)
    return TaskRowView(task: .constant(task))
        .padding()
}

#Preview("Complete Task") {
    let week = Week(startDate: Week.getCurrentWeekStart())
    let task = Task(text: "Example todo 2", isComplete: true, focusArea: .life, sortOrder: 1, week: week)
    return TaskRowView(task: .constant(task))
        .padding()
}

#Preview("Multiple Tasks") {
    let week = Week(startDate: Week.getCurrentWeekStart())
    let task1 = Task(text: "Example todo 3", isComplete: false, focusArea: .life, sortOrder: 2, week: week)
    let task2 = Task(text: "Example todo 2", isComplete: false, focusArea: .work, sortOrder: 1, week: week)
    let task3 = Task(text: "Example todo 1", isComplete: true, focusArea: .life, sortOrder: 0, week: week)

    return VStack(alignment: .leading, spacing: 8) {
        TaskRowView(task: .constant(task1))
        TaskRowView(task: .constant(task2))
        TaskRowView(task: .constant(task3))
    }
    .padding()
}
