//
//  ModelTests.swift
//  BulletJournalTodosTests
//
//  Unit tests for Task, Week, and FocusArea models
//

import XCTest
import SwiftData
@testable import BulletJournalTodos

@MainActor
final class ModelTests: XCTestCase {

    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUp() async throws {
        // Create in-memory model container for testing
        let schema = Schema([Task.self, Week.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        modelContext = modelContainer.mainContext
    }

    override func tearDown() async throws {
        modelContainer = nil
        modelContext = nil
    }

    // MARK: - Test: Adding/Removing Tasks Updates week.tasks

    func testAddingTaskToWeekUpdatesTasksArray() throws {
        // Given: A week with no tasks
        let startDate = Date()
        let week = Week(startDate: startDate, tasks: [])
        modelContext.insert(week)

        // When: Adding a task to the week
        let task = Task(text: "Test task", focusArea: .life, sortOrder: 0, week: week)
        modelContext.insert(task)
        week.tasks.append(task)

        // Then: The week's tasks array should contain the task
        XCTAssertEqual(week.tasks.count, 1, "Week should have 1 task after adding")
        XCTAssertEqual(week.tasks.first?.text, "Test task", "Task text should match")
        XCTAssertTrue(week.tasks.first === task, "Week should contain the exact task instance")
    }

    func testRemovingTaskFromWeekUpdatesTasksArray() throws {
        // Given: A week with one task
        let startDate = Date()
        let week = Week(startDate: startDate, tasks: [])
        modelContext.insert(week)

        let task = Task(text: "Test task", focusArea: .life, sortOrder: 0, week: week)
        modelContext.insert(task)
        week.tasks.append(task)

        // Verify setup
        XCTAssertEqual(week.tasks.count, 1, "Setup: Week should have 1 task")

        // When: Deleting the task from model context
        modelContext.delete(task)

        // Then: The week's tasks array should be automatically updated due to inverse relationship
        XCTAssertEqual(week.tasks.count, 0, "Week should have 0 tasks after deleting task (inverse relationship should update automatically)")
    }

    func testAddingMultipleTasksToWeek() throws {
        // Given: A week with no tasks
        let startDate = Date()
        let week = Week(startDate: startDate, tasks: [])
        modelContext.insert(week)

        // When: Adding multiple tasks
        let task1 = Task(text: "Task 1", focusArea: .life, sortOrder: 0, week: week)
        let task2 = Task(text: "Task 2", focusArea: .work, sortOrder: 1, week: week)
        let task3 = Task(text: "Task 3", focusArea: .life, sortOrder: 2, week: week)

        modelContext.insert(task1)
        modelContext.insert(task2)
        modelContext.insert(task3)

        week.tasks.append(contentsOf: [task1, task2, task3])

        // Then: The week should contain all three tasks
        XCTAssertEqual(week.tasks.count, 3, "Week should have 3 tasks")
        XCTAssertEqual(week.tasks[0].text, "Task 1")
        XCTAssertEqual(week.tasks[1].text, "Task 2")
        XCTAssertEqual(week.tasks[2].text, "Task 3")
    }

    // MARK: - Test: Week Creation with Monday Start Date

    func testWeekCreationWithMondayStartDate() throws {
        // Given: A date that may or may not be Monday
        let calendar = Calendar.current
        let today = Date()

        // When: Creating a week with the Monday of the current week
        let mondayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        let mondayStartDate = calendar.date(from: mondayComponents)!

        let week = Week(startDate: mondayStartDate)
        modelContext.insert(week)

        // Then: The week's start date should be a Monday
        let weekday = calendar.component(.weekday, from: week.startDate)
        XCTAssertEqual(weekday, 2, "Start date should be Monday (weekday = 2)")
    }

    func testWeekStartDateIsSetAtMidnight() throws {
        // Given: A date with a specific time component
        let calendar = Calendar.current
        let today = Date()

        // When: Creating a week with Monday at midnight
        let mondayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        let mondayStartDate = calendar.date(from: mondayComponents)!

        let week = Week(startDate: mondayStartDate)
        modelContext.insert(week)

        // Then: The time components should be at the start of day
        let components = calendar.dateComponents([.hour, .minute, .second], from: week.startDate)
        XCTAssertEqual(components.hour, 0, "Hour should be 0 (midnight)")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")
    }

    func testMultipleWeeksWithDifferentMondays() throws {
        // Given: Two different Monday dates
        let calendar = Calendar.current
        let today = Date()

        let thisMondayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        let thisMonday = calendar.date(from: thisMondayComponents)!

        // Get last Monday (7 days ago)
        var lastMondayComponents = thisMondayComponents
        lastMondayComponents.weekOfYear! -= 1
        let lastMonday = calendar.date(from: lastMondayComponents)!

        // When: Creating two weeks
        let thisWeek = Week(startDate: thisMonday)
        let lastWeek = Week(startDate: lastMonday)

        modelContext.insert(thisWeek)
        modelContext.insert(lastWeek)

        // Then: The weeks should have different start dates exactly 7 days apart
        let daysBetween = calendar.dateComponents([.day], from: lastWeek.startDate, to: thisWeek.startDate).day
        XCTAssertEqual(daysBetween, 7, "Weeks should be exactly 7 days apart")
    }

    // MARK: - Test: Task Sorting by sortOrder Descending

    func testTasksSortedBySortOrderDescending() throws {
        // Given: A week with tasks having different sortOrder values
        let week = Week(startDate: Date())
        modelContext.insert(week)

        let task1 = Task(text: "Oldest task", focusArea: .life, sortOrder: 0, week: week)
        let task2 = Task(text: "Middle task", focusArea: .life, sortOrder: 5, week: week)
        let task3 = Task(text: "Newest task", focusArea: .life, sortOrder: 10, week: week)

        modelContext.insert(task1)
        modelContext.insert(task2)
        modelContext.insert(task3)

        week.tasks.append(contentsOf: [task1, task2, task3])

        // When: Sorting tasks by sortOrder descending
        let sortedTasks = week.tasks.sorted { $0.sortOrder > $1.sortOrder }

        // Then: Tasks should be in descending order (highest sortOrder first)
        XCTAssertEqual(sortedTasks[0].text, "Newest task", "First should be highest sortOrder (10)")
        XCTAssertEqual(sortedTasks[1].text, "Middle task", "Second should be middle sortOrder (5)")
        XCTAssertEqual(sortedTasks[2].text, "Oldest task", "Third should be lowest sortOrder (0)")
    }

    func testTasksSortWithMixedFocusAreas() throws {
        // Given: Tasks from different focus areas with different sortOrders
        let week = Week(startDate: Date())
        modelContext.insert(week)

        let lifeTask1 = Task(text: "Life task 1", focusArea: .life, sortOrder: 2, week: week)
        let workTask1 = Task(text: "Work task 1", focusArea: .work, sortOrder: 5, week: week)
        let lifeTask2 = Task(text: "Life task 2", focusArea: .life, sortOrder: 8, week: week)
        let workTask2 = Task(text: "Work task 2", focusArea: .work, sortOrder: 1, week: week)

        modelContext.insert(lifeTask1)
        modelContext.insert(workTask1)
        modelContext.insert(lifeTask2)
        modelContext.insert(workTask2)

        week.tasks.append(contentsOf: [lifeTask1, workTask1, lifeTask2, workTask2])

        // When: Filtering and sorting life tasks by sortOrder descending
        let lifeTasks = week.tasks
            .filter { $0.focusArea == .life }
            .sorted { $0.sortOrder > $1.sortOrder }

        // Then: Life tasks should be sorted correctly
        XCTAssertEqual(lifeTasks.count, 2, "Should have 2 life tasks")
        XCTAssertEqual(lifeTasks[0].sortOrder, 8, "First life task should have sortOrder 8")
        XCTAssertEqual(lifeTasks[1].sortOrder, 2, "Second life task should have sortOrder 2")

        // When: Filtering and sorting work tasks
        let workTasks = week.tasks
            .filter { $0.focusArea == .work }
            .sorted { $0.sortOrder > $1.sortOrder }

        // Then: Work tasks should be sorted correctly
        XCTAssertEqual(workTasks.count, 2, "Should have 2 work tasks")
        XCTAssertEqual(workTasks[0].sortOrder, 5, "First work task should have sortOrder 5")
        XCTAssertEqual(workTasks[1].sortOrder, 1, "Second work task should have sortOrder 1")
    }

    func testTasksSortWithEqualSortOrders() throws {
        // Given: Tasks with the same sortOrder (edge case)
        let week = Week(startDate: Date())
        modelContext.insert(week)

        let task1 = Task(text: "Task A", focusArea: .life, sortOrder: 5, week: week)
        let task2 = Task(text: "Task B", focusArea: .life, sortOrder: 5, week: week)
        let task3 = Task(text: "Task C", focusArea: .life, sortOrder: 10, week: week)

        modelContext.insert(task1)
        modelContext.insert(task2)
        modelContext.insert(task3)

        week.tasks.append(contentsOf: [task1, task2, task3])

        // When: Sorting by sortOrder descending
        let sortedTasks = week.tasks.sorted { $0.sortOrder > $1.sortOrder }

        // Then: Task with sortOrder 10 should be first
        XCTAssertEqual(sortedTasks[0].sortOrder, 10, "First task should have sortOrder 10")

        // The two tasks with sortOrder 5 can be in any order relative to each other
        XCTAssertEqual(sortedTasks[1].sortOrder, 5, "Second task should have sortOrder 5")
        XCTAssertEqual(sortedTasks[2].sortOrder, 5, "Third task should have sortOrder 5")
    }

    // MARK: - Additional Model Tests

    func testTaskInitializationWithDefaults() throws {
        // Given: Creating a task with minimal parameters
        let task = Task(text: "Simple task", focusArea: .life, sortOrder: 0)

        // Then: Default values should be set correctly
        XCTAssertEqual(task.text, "Simple task")
        XCTAssertFalse(task.isComplete, "isComplete should default to false")
        XCTAssertEqual(task.focusArea, .life)
        XCTAssertEqual(task.sortOrder, 0)
        XCTAssertNil(task.week, "week should default to nil")
    }

    func testWeekInitializationWithDefaults() throws {
        // Given: Creating a week with minimal parameters
        let startDate = Date()
        let week = Week(startDate: startDate)

        // Then: Default values should be set correctly
        XCTAssertEqual(week.startDate, startDate)
        XCTAssertEqual(week.tasks.count, 0, "tasks should default to empty array")
    }

    func testTaskCompletionToggle() throws {
        // Given: A task that is not complete
        let task = Task(text: "Test task", focusArea: .life, sortOrder: 0)
        XCTAssertFalse(task.isComplete, "Task should start incomplete")

        // When: Toggling completion
        task.isComplete = true

        // Then: Task should be marked complete
        XCTAssertTrue(task.isComplete, "Task should be complete after toggle")

        // When: Toggling again
        task.isComplete = false

        // Then: Task should be incomplete again
        XCTAssertFalse(task.isComplete, "Task should be incomplete after second toggle")
    }

    func testFocusAreaEnumValues() throws {
        // Test that FocusArea enum has expected cases
        XCTAssertEqual(FocusArea.life.rawValue, "life")
        XCTAssertEqual(FocusArea.work.rawValue, "work")
    }
}
