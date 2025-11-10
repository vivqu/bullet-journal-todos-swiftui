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

    // Query tasks for current week only (database-level filtering by week)
    // This significantly reduces memory usage compared to loading all tasks
    private var currentWeekTasks: [Task] {
        guard let currentWeek = currentWeek else { return [] }

        let weekStart = currentWeek.startDate

        let descriptor = FetchDescriptor<Task>(
            predicate: #Predicate { task in
                task.week.startDate == weekStart
            },
            sortBy: [SortDescriptor(\.sortOrder, order: .reverse)]
        )

        return (try? modelContext.fetch(descriptor)) ?? []
    }

    // Filter by selected focus area (in-memory filtering for dynamic state)
    private var filteredTasks: [Task] {
        currentWeekTasks.filter { task in
            task.focusArea == selectedFocusArea
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
