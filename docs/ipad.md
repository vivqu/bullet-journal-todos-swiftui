# iPad Testing Guide

This guide provides comprehensive testing instructions for verifying iPad compatibility of the Bullet Journal Todos app.

## Quick Start

```bash
# Build and run on iPad Pro 13-inch (iOS 26)
cd BulletJournalTodos
xcodebuild -scheme BulletJournalTodos -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' \
  build

# Or use the MCP XcodeBuildMCP tools for automated testing
```

## Automated Testing Checklist

These tests can be automated using simulator commands and the MCP XcodeBuildMCP tools:

- [ ] Build and run on iPad simulator (iPad Pro 13-inch or iPad Air)
- [ ] Create multiple tasks in LIFE focus area
- [ ] Switch to WORK focus area and create tasks
- [ ] Toggle between LIFE/WORK, verify correct task filtering
- [ ] Test task completion via checkbox toggle
- [ ] Test sheet behaviors:
  - Swipe down to dismiss
  - Tap outside sheet to dismiss
  - Submit task via button
- [ ] Test focus area switching while sheet is open
- [ ] Restart app and verify data persistence
- [ ] Test dark mode appearance (`xcrun simctl ui appearance dark`)
- [ ] Test landscape orientation (rotation commands)
- [ ] Verify drag-to-reorder handles are visible

## Manual Interactive Testing

The following tests require physical interaction with the simulator UI and **cannot be automated** via command-line tools.

### 1. Drag-to-Reorder
**Why manual**: Requires long-press and drag gestures that simctl doesn't support.

**Steps:**
1. Open app on iPad simulator
2. Create 3+ tasks in LIFE
3. Long-press and drag a task to reorder
4. Verify sortOrder updates and persists
5. Repeat for WORK focus area

### 2. Empty State Testing
**Why manual**: Requires swipe-left gesture on list rows to reveal delete button.

**Steps:**
1. Switch to a focus area with tasks
2. Swipe left on each task and tap Delete
3. Verify empty state shows only "+ Create task" button
4. Create a new task, verify it appears correctly

**Limitation**: The MCP simulator tools don't support the precise swipe-left gesture needed for iOS list row deletion.

### 3. Split Screen Mode
**Why manual**: No `simctl` commands available for split screen control.

**Steps:**
1. Open BulletJournalTodos app
2. Open Safari or another app
3. Drag from right edge to enter split view
4. Test these configurations:
   - 50/50 split
   - 33/67 split (app on left)
   - 67/33 split (app on right)
5. For each split:
   - Verify UI doesn't look stretched
   - Test creating tasks
   - Test toggling focus areas
   - Verify sheet presentation looks correct

**Limitation**: Checked `xcrun simctl help | grep -i "split\|multi\|window\|layout"` - no commands available.

### 4. Slide Over Mode
**Why manual**: Requires app switcher interaction and drag gestures.

**Steps:**
1. Open BulletJournalTodos in full screen
2. Open another app (e.g., Notes)
3. Swipe from bottom to show app switcher
4. Drag Notes app to right edge for slide over
5. Verify:
   - BulletJournalTodos remains usable
   - Can create/complete tasks
   - Sheet presentation works correctly

### 5. Rotation Testing
**Partially automated**: Can use `Cmd+Left`/`Cmd+Right` in simulator UI, but testing sheet behavior during rotation requires manual interaction.

**Steps:**
1. Open BulletJournalTodos in portrait orientation
2. Rotate device/simulator to landscape (Cmd+Left or Cmd+Right)
3. Verify in landscape:
   - Layout adapts properly (no clipped content)
   - All UI elements remain accessible
   - Focus area toggle remains visible
   - "+ Create task" button positioned correctly
   - Task list scrolls properly
4. Open "+ Create task" sheet while in landscape
5. Verify:
   - Sheet appears correctly positioned
   - Text field is usable
   - Submit button accessible
   - Keyboard doesn't obscure content
6. Rotate back to portrait with sheet open
7. Verify sheet repositions correctly
8. Test rotation in split screen mode:
   - Open split screen (50/50)
   - Rotate to landscape
   - Verify both apps handle rotation gracefully
   - Return to portrait

## UI Polish Verification

Verify these design elements match the mockups on iPad:

### Colors
- [ ] Blue for active focus area toggle
- [ ] Gray for inactive focus area toggle
- [ ] Gray background on "+ Create task" button
- [ ] Blue circular + icon

**Expected values:**
- Active toggle: `.blue` (system color)
- Inactive toggle: `.primary` (adapts to light/dark mode)
- Button background: `.gray.opacity(0.2)`
- + icon: `.blue`

### Spacing
- [ ] Week header has proper top padding
- [ ] Focus toggle has good spacing below header
- [ ] Task list has appropriate spacing from toggle
- [ ] Each task row has consistent height and spacing

**Expected layout** (portrait on iPad Pro 13-inch):
- Week header: y ≈ 48px
- Focus toggle: y ≈ 88px
- Task list start: y ≈ 129px
- Task row height: 52px

### Checkbox Styling
- [ ] Completed tasks show filled checkbox (checkmark.square)
- [ ] Incomplete tasks show empty checkbox (square)
- [ ] Checkboxes properly positioned on left side of task rows

### Animations
- [ ] Sheet presentation uses smooth slide-up animation
- [ ] Keyboard appearance is smooth and non-jarring
- [ ] List scrolling is responsive and fluid

## iPad-Specific Verification

### Layout Scaling
- [ ] UI elements maintain proper proportions on larger screen
- [ ] Text remains readable and not over-scaled
- [ ] Content width appropriate for iPad screen
- [ ] Vertical spacing balanced throughout

### Sheet Presentation
- [ ] Sheet has improved bottom padding on iPad:
  - iOS 26+: 24pt (vs 16pt on iPhone)
  - iOS 17-25: 20pt (vs 8pt on iPhone)
- [ ] Sheet positioning visually balanced
- [ ] Keyboard doesn't obscure content

**Implementation reference**: See `AddTaskSheet.swift` lines 17-25 for device-aware padding logic.

## Testing on Different iPad Models

The app should work on all iPad models running iOS 17+. Test on a variety of screen sizes:

**Recommended simulators:**
- iPad Pro 13-inch (M4) - Largest screen
- iPad Pro 11-inch (M4) - Medium screen
- iPad mini (A17 Pro) - Smallest iPad screen
- iPad Air 11-inch (M3) - Standard size

**To list available iPad simulators:**
```bash
xcrun simctl list devices available | grep "iPad"
```

## Known Limitations

The following tests cannot be automated via command-line tools and require manual verification:

1. **Split screen mode** - No simctl API for split screen control
2. **Slide over mode** - Requires manual app switcher interaction
3. **Empty state via deletion** - Swipe gestures not supported by automation tools

These limitations are technical constraints of the simulator command-line interface, not app bugs.

## Troubleshooting

### Sheet appears off-center on iPad
- Verify the device-aware padding is applied correctly in `AddTaskSheet.swift`
- Check that iOS version detection is working: `@available(iOS 26.0, *)`

### UI looks stretched or awkward
- Verify the app is using system spacing and padding
- Check that SwiftUI's adaptive layout is not overridden with fixed values

### Simulator rotation not working
- Use keyboard shortcuts: Cmd+Left (rotate left), Cmd+Right (rotate right)
- Or use: Device → Rotate Left/Right in simulator menu

### App crashes on iPad but not iPhone
- Check for iPhone-specific APIs or assumptions
- Verify `UIDevice.current.userInterfaceIdiom` checks are correct
- Review any device-specific code paths
