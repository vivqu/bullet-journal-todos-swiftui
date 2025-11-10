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
    @Query private var weeks: [Week]
    @State private var selectedFocusArea: FocusArea = .life
    @State private var showAddTaskSheet = false
    @State private var taskToEdit: Task?

    // Get the current week
    private var currentWeek: Week? {
        let currentWeekStart = Week.getCurrentWeekStart()
        return weeks.first { $0.startDate == currentWeekStart }
    }

    // Get all tasks sorted by sortOrder descending
    @Query(sort: \Task.sortOrder, order: .reverse) private var allTasks: [Task]

    // Filter tasks by current week and selected focus area
    private var filteredTasks: [Task] {
        guard let currentWeek = currentWeek else { return [] }
        return allTasks.filter { task in
            task.week.startDate == currentWeek.startDate && task.focusArea == selectedFocusArea
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WeekHeaderView(weekStartDate: Week.getCurrentWeekStart())
                .padding(.horizontal)
                .padding(.top)

            FocusAreaToggle(selectedFocusArea: $selectedFocusArea)
                .padding(.horizontal)

            TaskListView(
                tasks: Binding(
                    get: { filteredTasks },
                    set: { newTasks in
                        // Updates to individual tasks are handled through bindings in TaskRowView
                        // We don't need to handle the set case here since tasks are updated directly via modelContext
                    }
                ),
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
        // Get filtered tasks for current focus area, sorted by sortOrder descending
        var tasksToReorder = filteredTasks

        // Reorder the filtered array
        tasksToReorder.move(fromOffsets: source, toOffset: destination)

        // Recalculate sortOrder values (highest to lowest)
        let count = tasksToReorder.count
        for (index, task) in tasksToReorder.enumerated() {
            task.sortOrder = count - 1 - index
        }

        // Save changes to SwiftData
        do {
            try modelContext.save()
        } catch {
            assertionFailure("⚠️ Failed to save reordered tasks: \(error)")
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
