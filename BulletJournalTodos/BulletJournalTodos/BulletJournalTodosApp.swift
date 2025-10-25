//
//  BulletJournalTodosApp.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/11/25.
//

import SwiftUI
import SwiftData

@main
struct BulletJournalTodosApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
            Week.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        ensureCurrentWeekExists()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }

    /// Checks if a Week exists for the current week (Monday-based) and creates it if needed
    /// Validates that only one instance of each week exists
    private func ensureCurrentWeekExists() {
        let currentWeekStart = Week.getCurrentWeekStart()
        let context = ModelContext(sharedModelContainer)

        // Query for weeks with the current week's start date
        let descriptor = FetchDescriptor<Week>(
            predicate: #Predicate { week in
                week.startDate == currentWeekStart
            }
        )

        do {
            let existingWeeks = try context.fetch(descriptor)

            if existingWeeks.count > 1 {
                // Data integrity warning - multiple weeks with same start date
                // Return first one to keep app running, but alert developer
                assertionFailure("⚠️ Data integrity warning: Found \(existingWeeks.count) weeks with start date \(currentWeekStart). Only one week per start date should exist. Using first instance.")
            } else if existingWeeks.isEmpty {
                // No week exists for current week - create one
                let newWeek = Week(startDate: currentWeekStart)
                context.insert(newWeek)
                try context.save()
            }
            // If exactly one week exists, no action needed
        } catch {
            // Log error but don't crash - app can still function
            assertionFailure("⚠️ Failed to check or create current week: \(error)")
        }
    }
}
