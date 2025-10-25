# Development Workflow

This document outlines the development workflow for this project when working with Claude Code.

## Before Starting Each Task

**CRITICAL: Git branch management**

1. **Check for uncommitted changes:**
   ```bash
   git status
   ```

2. **If there are uncommitted changes:**
   - Review all changes with the user
   - Ask whether to commit them or discard them
   - WAIT for user decision before proceeding
   - If committing: use conventional commit messages
   - If discarding: use `git restore <file>` or `git clean -fd` for untracked files

3. **Create a new branch for the task:**
   ```bash
   git checkout -b task/<task-number>-<brief-description>
   ```
   - Example: `git checkout -b task/1-create-swiftdata-models`
   - Example: `git checkout -b task/4-build-week-header-view`

## During Task Execution

1. **Use TodoWrite tool** to track task progress
2. **Make small, focused commits** as you complete logical units of work:
   - Prefer multiple small commits over one large commit
   - Each commit should represent a single, coherent change
   - Stack commits to build up functionality incrementally
   - Examples:
     - ✅ Commit 1: "refactor: simplify Task initializer"
     - ✅ Commit 2: "fix: force Monday as first weekday"
     - ❌ Avoid: One commit with "refactor Task + fix calendar + update docs"
3. **Build frequently** to catch compilation errors early

## After Completing Each Task

**IMPORTANT: Always perform these steps after each task completion:**

1. **Build the project** to verify compilation:
   ```bash
   cd BulletJournalTodos
   # Default to iPhone 17 (iOS 26) for testing
   xcodebuild -scheme BulletJournalTodos -sdk iphonesimulator \
     -destination 'platform=iOS Simulator,name=iPhone 17' build
   ```

2. **Run the app in iOS Simulator** for user review:
   ```bash
   # Boot an iOS 17+ simulator if needed
   open -a Simulator

   # Find the built app (adjust path based on your build)
   APP_PATH="./build/Build/Products/Debug-iphonesimulator/BulletJournalTodos.app"

   # Install and launch app
   xcrun simctl install booted "$APP_PATH"
   xcrun simctl launch booted com.vivqu.BulletJournalTodos
   ```

3. **Take a screenshot** (optional, for documentation):
   ```bash
   xcrun simctl io booted screenshot screenshot-task-<N>.png
   ```

4. **Wait for user approval** before proceeding to the next task
   - User will review the running app in simulator
   - User may request changes or approve to continue

5. **Review code for style and language compliance:**
   - Review all modified Swift files against the style guide in `docs/swift.md`
   - Fix any violations (e.g., force unwrapping, naming conventions, etc.)
   - Ensure code follows Swift best practices and project conventions
   - Re-run tests after style fixes to verify correctness

6. **After user approval, update plan.md:**
   - Mark the completed task with `[x]` in plan.md
   - Example: Change `- [ ] 1. Create SwiftData models` to `- [x] 1. Create SwiftData models`
   - This keeps the plan in sync with actual progress

## Committing Changes

When creating commits, follow these guidelines:

1. **Use conventional commit format:**
   - `feat: add SwiftData models for Task, Week, and FocusArea`
   - `fix: correct relationship between Task and Week models`
   - `refactor: extract view components into separate files`
   - `docs: update CLAUDE.md with architecture notes`
   - `test: add unit tests for Week model`

2. **Include co-author attribution:**
   ```bash
   git commit -m "feat: <description>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

## Available Simulators

The project requires **iOS 17.0** or later (SwiftData minimum requirement).

**Default simulator for testing:** iPhone 17 or latest iOS 26+ device
- Always use the latest iOS version (iOS 26+) for primary testing
- This ensures we're testing with the latest APIs and behaviors
- Only test on older iOS versions (iOS 17-25) when specifically requested for compatibility verification

**Recommended iOS 26+ simulators:**
- iPhone 17, iPhone 17 Pro, iPhone 17 Pro Max
- iPhone Air, iPhone 16e

**To list available simulators:**
```bash
xcrun simctl list devices available | grep "iPhone"
```

## Troubleshooting

### App won't install on simulator
- Verify simulator is running iOS 17.0 or later
- Check minimum deployment target in project settings
- Try: `xcrun simctl erase all` (WARNING: deletes all simulator data)

### Build fails with "Item.self not found"
- The old `Item.swift` template file may need to be removed from the project
- Verify new models are properly imported in `BulletJournalTodosApp.swift`

### Simulator shows old version of app
- Uninstall app from simulator first: `xcrun simctl uninstall booted com.vivqu.BulletJournalTodos`
- Clean build folder: `cd BulletJournalTodos && xcodebuild clean`
