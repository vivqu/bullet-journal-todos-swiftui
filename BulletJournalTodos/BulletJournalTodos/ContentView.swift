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

    private var sheetHeight: CGFloat {
        if #available(iOS 26.0, *) {
            return 100
        } else {
            return 80
        }
    }

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
                task.week?.startDate == weekStart
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
        VStack(alignment: .leading, spacing: 20) {
            WeekHeaderView(weekStartDate: Week.getCurrentWeekStart())
                .padding(.horizontal, 20)
                .padding(.top, 16)

            FocusAreaToggle(selectedFocusArea: $selectedFocusArea)
                .padding(.horizontal, 20)

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
                handleTaskSubmit(text: text)
            }
            .presentationDetents([.height(sheetHeight)])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
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

    private func handleTaskSubmit(text: String) {
        guard let currentWeek else {
            assertionFailure("⚠️ Cannot create task: current week not found")
            return
        }

        // Calculate new sortOrder: max sortOrder in current focus area + 1, or 0 if no tasks
        let maxSortOrder = filteredTasks.map { $0.sortOrder }.max() ?? -1
        let newSortOrder = maxSortOrder + 1

        // Create new task (without week to avoid relationship crash)
        let newTask = Task(
            text: text,
            isComplete: false,
            focusArea: selectedFocusArea,
            sortOrder: newSortOrder
        )

        // Insert into modelContext first
        modelContext.insert(newTask)

        // Now set the week relationship after task is managed by context
        newTask.week = currentWeek

        // Save changes
        do {
            try modelContext.save()
        } catch {
            assertionFailure("⚠️ Failed to save new task: \(error)")
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
