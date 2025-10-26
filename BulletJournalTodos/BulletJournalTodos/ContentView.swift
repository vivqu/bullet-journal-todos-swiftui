//
//  ContentView.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var mockTasks: [TaskViewModel] = [
        TaskViewModel(text: "Example todo 3", isComplete: false, sortOrder: 2),
        TaskViewModel(text: "Example todo 2", isComplete: false, sortOrder: 1),
        TaskViewModel(text: "Example todo 1", isComplete: false, sortOrder: 0)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WeekHeaderView(weekStartDate: Week.getCurrentWeekStart())
                .padding(.horizontal)
                .padding(.top)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(mockTasks.sorted(by: { $0.sortOrder > $1.sortOrder }), id: \.sortOrder) { task in
                    TaskRowView(task: binding(for: task))
                }

                CreateTaskButton {
                    print("Create task button tapped")
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    private func binding(for task: TaskViewModel) -> Binding<TaskViewModel> {
        guard let index = mockTasks.firstIndex(where: { $0.sortOrder == task.sortOrder }) else {
            fatalError("Task not found in mockTasks")
        }
        return $mockTasks[index]
    }
}

#Preview {
    let schema = Schema([Task.self, Week.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])

    return ContentView()
        .modelContainer(container)
}
