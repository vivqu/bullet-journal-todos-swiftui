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
    @State private var showAddTaskSheet = false
    @State private var taskToEdit: Task?
    @State private var mockTasks: [Task] = {
        let week = Week(startDate: Week.getCurrentWeekStart())
        return [
            Task(text: "Example todo 5", isComplete: false, focusArea: .work, sortOrder: 4, week: week),
            Task(text: "Example todo 4", isComplete: false, focusArea: .work, sortOrder: 3, week: week),
            Task(text: "Example todo 3", isComplete: false, focusArea: .life, sortOrder: 2, week: week),
            Task(text: "Example todo 2", isComplete: false, focusArea: .life, sortOrder: 1, week: week),
            Task(text: "Example todo 1", isComplete: false, focusArea: .life, sortOrder: 0, week: week)
        ]
    }()

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
                    taskToEdit = nil
                    showAddTaskSheet = true
                }
            )
        }
        .sheet(isPresented: $showAddTaskSheet) {
            AddTaskSheet(task: taskToEdit) { text in
                print("Task submitted: \(text)")
                // TODO: Create or update task in SwiftData
            }
            .presentationDetents([.height(100)])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .presentationBackground(.white)
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
