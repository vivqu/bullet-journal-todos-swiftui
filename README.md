# Bullet Journal Todos

A SwiftUI app that brings bullet journaling concepts to digital task management. This app adapts traditional bullet journaling for mobile, helping users organize tasks across two focus areas: **Life** and **Work**.

## Overview

Bullet journaling is a customizable analog system for organization, mindfulness, and productivity. This app digitizes the core concepts while maintaining the intentional, reflection-driven approach that makes bullet journaling effective.

## Core Features

### Current Implementation (MVP)
- **Weekly Pages**: Each week (starting Monday) gets a fresh page for tasks
- **Dual Focus Areas**: Toggle between "LIFE" and "WORK" to view context-specific tasks
- **Task Management**: Create, complete, and reorder tasks within each focus area
- **Persistent Storage**: Tasks are saved using SwiftData and persist across app sessions
- **Simple UI**: Clean, minimal interface inspired by paper bullet journals

### Planned Features
- **Task States**:
  - ✓ Complete (checked)
  - → Carried over (marked with right arrow)
  - ✗ Deprioritized/No longer needed
- **Manual Carry-Over**: Intentionally move incomplete tasks to the current week, providing a built-in reflection point
- **Week Navigation**: Browse previous weeks to see historical tasks
- **Custom Sections**: Organize tasks with user-defined category headers (e.g., "Logistics", "Urgent", "Creative hobbies")
- **Carry-Over Tracking**: Count how many times a task has been carried week-over-week