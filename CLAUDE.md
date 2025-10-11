# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI mobile app that implements a digital bullet journal system for task management. The app adapts traditional bullet journaling concepts for digital todo management with two focus areas: personal life and work.

### Core Concept

- **Weekly Pages**: Each Monday opens a new blank page. Users can navigate to previous weeks to see historical tasks.
- **Task States**: Tasks can be:
  - Incomplete (unchecked)
  - Complete (checked)
  - Carried over (marked with right arrow →)
  - Deprioritized/No longer needed (marked with X)
- **Manual Carry-Over**: Incomplete tasks from previous weeks can be manually carried forward to the current week. This is intentionally manual to encourage reflection on task importance.
- **Categorization**: Tasks are organized into user-defined sections (e.g., "Logistics", "Urgent", "Creative hobbies") within personal and work focus areas.

## Build and Run

This is a standard Xcode project for iOS.

**To build and run:**
```bash
open BulletJournalTodos/BulletJournalTodos.xcodeproj
```
Then use Xcode's build (Cmd+B) and run (Cmd+R) commands.

**To run on iOS Simulator:**
Use Xcode's scheme selector to choose a target device, then press Cmd+R.

## Architecture

### Data Layer - SwiftData

The app uses **SwiftData** (Apple's modern data persistence framework) for storage:

- `BulletJournalTodosApp.swift:13-24`: Sets up the ModelContainer with the schema
- Models are defined using the `@Model` macro
- Currently `Item.swift` contains a placeholder model that needs to be evolved into the full task data model

### Key Components to Implement

The current codebase is a starter template. The architecture will need:

1. **Data Models**:
   - Week model (start date, tasks collection)
   - Task model (title, category/section, state, focus area, carry-over count)
   - Section/Category model (custom headers per focus area)

2. **View Layer**:
   - Current week view (active todo list)
   - Week navigation (bottom navigator for previous weeks)
   - Task management UI (add, complete, carry-over, deprioritize)
   - Section headers (user-customizable categories)

3. **Business Logic**:
   - Week detection and creation (Monday rollover)
   - Task state transitions (incomplete → complete/carried-over/deprioritized)
   - Carry-over mechanism (duplicate task + mark original)

### SwiftData Integration Notes

- The app uses SwiftData's `@Query` property wrapper for reactive data fetching (see `ContentView.swift:13`)
- Model context is accessed via `@Environment(\.modelContext)` for inserts/deletes/updates
- The ModelContainer is configured for persistent storage (not in-memory) in the app entry point

## Development Notes

- This is an early-stage project with starter template code
- The current `Item` model is a placeholder and will need to be replaced with proper task/week models
- SwiftUI previews are configured for in-memory testing (see `ContentView.swift:58-61`)