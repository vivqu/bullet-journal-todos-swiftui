//
//  TaskListView.swift
//  BulletJournalTodos
//
//  Created by Claude on 11/4/25.
//

import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    let focusArea: FocusArea
    let onMove: (IndexSet, Int) -> Void
    let onCreateTask: () -> Void

    var filteredTasks: [Task] {
        tasks.filter { $0.focusArea == focusArea }
            .sorted(by: { $0.sortOrder > $1.sortOrder })
    }

    var body: some View {
        if filteredTasks.isEmpty {
            // Empty state: show CreateTaskButton
            VStack(alignment: .leading, spacing: 8) {
                CreateTaskButton(action: onCreateTask)
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else {
            // Show tasks in a List with CreateTaskButton at bottom
            List {
                ForEach(filteredTasks) { task in
                    TaskRowView(task: binding(for: task))
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onMove(perform: onMove)

                // CreateTaskButton at the bottom of the list
                CreateTaskButton(action: onCreateTask)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(.active))
        }
    }

    private func binding(for task: Task) -> Binding<Task> {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found in tasks array")
        }
        return $tasks[index]
    }
}

#Preview("Empty State") {
    TaskListView(
        tasks: .constant([]),
        focusArea: .life,
        onMove: { _, _ in },
        onCreateTask: { print("Create task tapped") }
    )
}

#Preview("With Tasks") {
    let week = Week(startDate: Week.getCurrentWeekStart())
    return TaskListView(
        tasks: .constant([
            Task(text: "Example todo 3", isComplete: false, focusArea: .life, sortOrder: 2, week: week),
            Task(text: "Example todo 2", isComplete: false, focusArea: .life, sortOrder: 1, week: week),
            Task(text: "Example todo 1", isComplete: true, focusArea: .life, sortOrder: 0, week: week)
        ]),
        focusArea: .life,
        onMove: { _, _ in },
        onCreateTask: { print("Create task tapped") }
    )
}

#Preview("Work Focus Area") {
    let week = Week(startDate: Week.getCurrentWeekStart())
    return TaskListView(
        tasks: .constant([
            Task(text: "Example work 2", isComplete: false, focusArea: .work, sortOrder: 1, week: week),
            Task(text: "Example work 1", isComplete: false, focusArea: .work, sortOrder: 0, week: week)
        ]),
        focusArea: .work,
        onMove: { _, _ in },
        onCreateTask: { print("Create task tapped") }
    )
}
