# Bullet Journal Todos - Development Plan

## Phase 1: Data Foundation

- [x] 1. Create SwiftData models
  - Task model: `text: String`, `isComplete: Bool`, `focusArea: FocusArea`, `sortOrder: Int`, `createdAt: Date`, `week: Week`
    - Note: `createdAt` tracks when task was originally created (useful for carry-over tracking and debugging)
    - Note: `week` is non-optional - tasks must belong to a week
    - Note: Task text is stored exactly as provided by user (including empty strings and whitespace)
  - Week model: `startDate: Date`, `tasks: [Task]`
  - FocusArea enum: `.life`, `.work`

- [x] 2. Create unit tests for data models
  - Test adding/removing tasks updates `week.tasks`
  - Test week creation with Monday start date
  - Test task sorting by `sortOrder` descending

- [x] 3. Add app launch logic
  - Check if Week exists for current week (Monday-based)
  - Create Week if needed

## Phase 2: Core UI Components (Build + Test Incrementally)

**IMPORTANT**: For ALL Phase 2 tasks, consult the mockups in [mocks/](mocks/) directory to ensure UI implementation matches the designs as closely as possible. Key mockups:
- [main-screen.png](mocks/main-screen.png) - LIFE focus area selected
- [work-selected-main-screen.png](mocks/work-selected-main-screen.png) - WORK focus area selected
- [add-new-task.png](mocks/add-new-task.png) - Add task sheet

- [x] 4. Build WeekHeaderView
  - Display "Week of [date]" with date formatting (format: "MMM d" without year)
  - Takes Date parameter (expects Monday start date)
  - Left-aligned text
  - Note: Always pass Monday date using `Week.getCurrentWeekStart()`, not current date

- [x] 5. Add WeekHeaderView to main screen for testing
  - Replace ContentView with basic layout
  - Add WeekHeaderView with Monday date (`Week.getCurrentWeekStart()`)
  - Verify rendering and left alignment

- [x] 6. Build CreateTaskButton
  - Gray pill button with "+ Create task" text
  - Takes action closure for tap handling

- [x] 7. Add CreateTaskButton to main screen for testing
  - Add below WeekHeaderView
  - Hook up tap action (prints to console)
  - Verify button appearance and tap

- [x] 8. Build TaskRowView
  - Checkbox (empty square) + task text
  - Tap checkbox to toggle `isComplete` on binding
  - Takes Task binding

- [ ] 9. Add TaskRowView to main screen with mock data
  - Create struct for mock Task data (not SwiftData yet)
  - Display 2-3 TaskRows with sample text
  - Add @State for mock completion toggling
  - Verify checkbox interaction

- [ ] 10. Build FocusAreaToggle
  - "LIFE / WORK" side-by-side buttons
  - Blue text for active, black for inactive
  - Takes binding to FocusArea selection

- [ ] 11. Add FocusAreaToggle to main screen for testing
  - Add below WeekHeaderView, above tasks
  - Wire to @State variable
  - Verify toggle switches and colors update

- [ ] 12. Build TaskListView
  - Scrollable List of TaskRows
  - Accepts array of tasks + focusArea filter
  - Sorted by `sortOrder` descending (highest first)
  - `.onMove` modifier for drag-to-reorder
  - CreateTaskButton at bottom (or as empty state)

- [ ] 13. Add TaskListView to main screen with mock data
  - Remove previous demo TaskRows
  - Create mock tasks for LIFE (3 tasks) and WORK (2 tasks)
  - Assign different sortOrder values to mock tasks
  - Wire FocusAreaToggle to filter displayed tasks
  - Verify filtering when toggle switches
  - Verify drag-to-reorder updates visual order
  - Verify empty state shows button

- [ ] 14. Build AddTaskSheet
  - Bottom sheet modal with rounded container
  - TextField with auto-focus (`.focused` modifier)
  - Blue circular "+" button (right-aligned)
  - On submit: clear text field, dismiss sheet
  - Swipe down or tap outside to dismiss

- [ ] 15. Wire AddTaskSheet to CreateTaskButton for testing
  - CreateTaskButton sets @State to show sheet
  - Sheet presents with TextField focused
  - Enter text and press "+" dismisses sheet
  - Verify swipe-to-dismiss works
  - Verify keyboard appears/dismisses correctly

## Phase 3: Data Integration (Consolidated)

- [ ] 16. Set up data query and context in main view
  - Add `@Query` for current week's tasks
  - Add `@Environment(\.modelContext)` for mutations
  - Replace WeekHeaderView hardcoded date with current week date
  - Verify app launches with current week created

- [ ] 17. Wire TaskListView to SwiftData queries
  - Replace mock tasks with filtered `@Query` results
  - Filter by `selectedFocusArea` using SwiftData predicate
  - Sort by `sortOrder` descending
  - Test that tasks persist across app restarts
  - Verify empty state when no tasks exist

- [ ] 18. Implement task creation flow
  - On AddTaskSheet submit:
    - Calculate new sortOrder (find max sortOrder + 1, or 0 if no tasks)
    - Create Task with text, current focusArea, new sortOrder, isComplete=false
    - Insert into modelContext
    - Clear text field and dismiss sheet
  - Add ScrollViewReader to TaskListView
  - Scroll to top after task creation
  - Test creating tasks in LIFE, then WORK, verify correct focus area

- [ ] 19. Implement task completion toggle
  - Wire TaskRowView checkbox to update Task.isComplete in SwiftData
  - Verify changes persist
  - Test toggling multiple tasks

- [ ] 20. Implement drag-to-reorder with sortOrder updates
  - On `.onMove`:
    - Reorder tasks array
    - Recalculate sortOrder values (highest to lowest)
    - Update each task's sortOrder in modelContext
  - Test reordering within LIFE and WORK separately
  - Verify order persists after app restart

## Phase 4: Final Manual Testing & Polish

- [ ] 21. End-to-end manual testing
  - Create multiple tasks in LIFE focus area
  - Switch to WORK, create multiple tasks there
  - Toggle between LIFE/WORK, verify correct tasks shown
  - Reorder tasks in each focus area independently
  - Complete/uncomplete tasks, verify persistence
  - Test empty state (delete all tasks in one area)
  - Test sheet behaviors: swipe dismiss, tap outside, submit
  - Test focus area switching while sheet is open
  - Restart app, verify all data persists

- [ ] 22. UI polish to match mockups
  - Verify colors: blue for active toggle, gray button, blue circular +
  - Check spacing between components
  - Ensure checkbox styling matches mockup
  - Test smooth animations (sheet, keyboard, scroll)
  - Test on multiple iPhone simulator sizes (SE, 14, Pro Max)

---

## Implementation Notes

### Sort Order Strategy (Reverse Integer)
- **New tasks**: Find `max(sortOrder)` of existing tasks in that focus area, add 1 (or use 0 if no tasks)
- **Display order**: Sort by `sortOrder` DESC (highest first)
- **Drag-to-reorder**: After reorder, recalculate sortOrder as: N-1, N-2, N-3... (where N is count)
- **Pros**: Simple, predictable, no floating point issues
- **Cons**: Requires updating all tasks on reorder (acceptable for prototype)

### SwiftData Query Pattern
```swift
@Query(filter: #Predicate<Task> { task in
    task.focusArea == selectedFocusArea
}, sort: \Task.sortOrder, order: .reverse)
var tasks: [Task]
```

### Week Detection (Monday-based)
```swift
let calendar = Calendar.current
let monday = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
let weekStart = calendar.date(from: monday)!
```

### Scroll to Top After Task Creation
```swift
ScrollViewReader { proxy in
    List {
        // tasks
    }
    .onChange(of: taskCount) {
        proxy.scrollTo(topTaskId, anchor: .top)
    }
}
```

---

## Known Risks & Edge Cases (Rapid Prototype)

### Risk 1: Drag-to-reorder might be finicky
- **Issue**: SwiftUI's List + `.onMove` can be temperamental with custom data models
- **Mitigation**: Test frequently during step 13, adjust approach if needed
- **Fallback**: If too buggy, defer reordering to future iteration

### Risk 2: Sheet + Keyboard + Scroll coordination
- **Issue**: Keyboard covering content, scroll position jumping, sheet dismiss timing
- **Mitigation**: Test step 15 thoroughly, use `.ignoresSafeArea(.keyboard)` if needed
- **Edge cases to watch**:
  - Keyboard dismisses but sheet stays open
  - Scroll position jumps when keyboard appears
  - Sheet doesn't dismiss on swipe with keyboard open

### Risk 3: Filter switching while sheet is open
- **Issue**: User toggles LIFE/WORK while AddTaskSheet is visible
- **Expected behavior**: Sheet stays open, new task goes to newly selected area
- **Mitigation**: Test explicitly in step 21, verify focusArea binding reads latest value

### Risk 4: Empty state layout
- **Issue**: CreateTaskButton positioning might look odd when no tasks exist
- **Mitigation**: Test in step 13 with empty mock array, adjust layout if needed

### Risk 5: sortOrder calculation edge cases
- **Issue**: What if multiple tasks have same sortOrder? What if sortOrder overflows Int.max?
- **Mitigation**: For prototype, assume normal usage (<1000 tasks). Document for future
- **Edge case to test**: Create task, reorder, create another task - verify correct ordering

### Risk 6: Week creation timing
- **Issue**: App launch might be slow if week creation happens on main thread
- **Mitigation**: Test in step 16, verify smooth launch. Move to background if needed

---

## Future Considerations (Post-Prototype)

- **Implement data migration strategy:** Currently no versioning or migration scheme in place. Before adding task state transitions, carry-over features, or other model changes, implement SwiftData lightweight migrations to prevent breaking existing user data. Address before production release.
