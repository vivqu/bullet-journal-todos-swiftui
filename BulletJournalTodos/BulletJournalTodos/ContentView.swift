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
    @State private var selectedFocusArea: FocusArea = .life
    @State private var mockTasks: [TaskViewModel] = [
        TaskViewModel(text: "Example todo 5", isComplete: false, sortOrder: 4, focusArea: .work),
        TaskViewModel(text: "Example todo 4", isComplete: false, sortOrder: 3, focusArea: .work),
        TaskViewModel(text: "Example todo 3", isComplete: false, sortOrder: 2, focusArea: .life),
        TaskViewModel(text: "Example todo 2", isComplete: false, sortOrder: 1, focusArea: .life),
        TaskViewModel(text: "Example todo 1", isComplete: false, sortOrder: 0, focusArea: .life)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WeekHeaderView(weekStartDate: Week.getCurrentWeekStart())
                .padding(.horizontal)
                .padding(.top)

            FocusAreaToggle(selectedFocusArea: $selectedFocusArea)
                .padding(.horizontal)

            TaskListView(
                tasks: $mockTasks,
                focusArea: selectedFocusArea,
                onMove: handleMove,
                onCreateTask: {
                    print("Create task button tapped")
                }
            )
        }
    }

    private func handleMove(from source: IndexSet, to destination: Int) {
        // Get filtered tasks for current focus area
        var filteredTasks = mockTasks.filter { $0.focusArea == selectedFocusArea }
            .sorted(by: { $0.sortOrder > $1.sortOrder })

        // Reorder the filtered array
        filteredTasks.move(fromOffsets: source, toOffset: destination)

        // Recalculate sortOrder values (highest to lowest)
        let count = filteredTasks.count
        for (index, task) in filteredTasks.enumerated() {
            if let originalIndex = mockTasks.firstIndex(where: { $0.id == task.id }) {
                mockTasks[originalIndex].sortOrder = count - 1 - index
            }
        }
    }
}

#Preview {
    let schema = Schema([Task.self, Week.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])

    return ContentView()
        .modelContainer(container)
}
