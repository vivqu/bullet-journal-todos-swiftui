# Test Setup Instructions

This document contains instructions for adding the unit test target to the Xcode project.

## Test File Created

The unit tests have been created in:
- `BulletJournalTodos/BulletJournalTodosTests/ModelTests.swift`

This file contains comprehensive tests for:
1. **Adding/Removing tasks updates `week.tasks`**: Tests that the relationship between Task and Week works correctly
2. **Week creation with Monday start date**: Tests that weeks are created with proper Monday-based start dates
3. **Task sorting by `sortOrder` descending**: Tests that tasks can be sorted correctly by their sortOrder property

## Adding the Test Target to Xcode

Since test targets need to be properly configured in the Xcode project, follow these steps:

### Option 1: Add Test Target via Xcode (Recommended)

1. Open the project in Xcode:
   ```bash
   open BulletJournalTodos/BulletJournalTodos.xcodeproj
   ```

2. In Xcode, go to **File → New → Target...**

3. Select **iOS → Unit Testing Bundle** and click **Next**

4. Configure the test target:
   - **Product Name**: `BulletJournalTodosTests`
   - **Team**: Select your development team
   - **Organization Identifier**: `com.vivqu`
   - **Bundle Identifier**: `com.vivqu.BulletJournalTodosTests`
   - **Project**: `BulletJournalTodos`
   - **Target to be Tested**: `BulletJournalTodos`
   - Click **Finish**

5. Delete the default test file that Xcode creates (it will be named something like `BulletJournalTodosTests.swift`)

6. Add our existing `ModelTests.swift` file to the project:
   - Right-click on the `BulletJournalTodosTests` folder in Xcode
   - Select **Add Files to "BulletJournalTodos"...**
   - Navigate to `BulletJournalTodos/BulletJournalTodosTests/ModelTests.swift`
   - Make sure **"BulletJournalTodosTests" target** is checked
   - Click **Add**

7. Ensure the test target has access to the main app's code:
   - Select the `BulletJournalTodos` target
   - Go to **Build Settings**
   - Search for "Enable Testing Search Paths"
   - Ensure **Enable Testability** is set to **Yes** (it already is)

### Option 2: Verify Test Target in Scheme

1. In Xcode, go to **Product → Scheme → Edit Scheme...**
2. Select **Test** in the left sidebar
3. Click the **+** button under "Test" if `BulletJournalTodosTests` is not listed
4. Add `BulletJournalTodosTests` to the test action

## Running the Tests

Once the test target is configured:

### Via Xcode:
- Press **Cmd+U** to run all tests
- Click the diamond icon next to individual test methods to run specific tests

### Via Command Line:
```bash
cd BulletJournalTodos
xcodebuild test -scheme BulletJournalTodos \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Test Coverage

The `ModelTests.swift` file includes:

### Adding/Removing Tasks Tests:
- `testAddingTaskToWeekUpdatesTasksArray`: Verifies adding a task updates the week's tasks array
- `testRemovingTaskFromWeekUpdatesTasksArray`: Verifies removing a task updates the week's tasks array
- `testAddingMultipleTasksToWeek`: Tests adding multiple tasks to a single week

### Week Creation Tests:
- `testWeekCreationWithMondayStartDate`: Ensures week start dates are always Monday
- `testWeekStartDateIsSetAtMidnight`: Verifies start dates are at midnight
- `testMultipleWeeksWithDifferentMondays`: Tests creating multiple weeks with correct Monday spacing

### Task Sorting Tests:
- `testTasksSortedBySortOrderDescending`: Verifies tasks sort correctly by sortOrder (highest first)
- `testTasksSortWithMixedFocusAreas`: Tests sorting works correctly when filtering by focus area
- `testTasksSortWithEqualSortOrders`: Edge case test for tasks with identical sortOrder values

### Additional Tests:
- `testTaskInitializationWithDefaults`: Verifies default values for Task initialization
- `testWeekInitializationWithDefaults`: Verifies default values for Week initialization
- `testTaskCompletionToggle`: Tests toggling task completion state
- `testFocusAreaEnumValues`: Validates FocusArea enum values

## Notes

- All tests use an in-memory SwiftData model container for isolation
- Tests are marked with `@MainActor` for SwiftData compatibility
- The tests follow the Given-When-Then pattern for clarity
