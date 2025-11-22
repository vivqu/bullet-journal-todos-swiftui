# iPad Testing Guide

Reference guide for automated and manual iPad compatibility testing.

## Build for iPad

```bash
# iPad Pro 13-inch (iOS 26) - recommended
xcodebuild -scheme BulletJournalTodos -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' build

# Or use MCP XcodeBuildMCP tools
mcp__XcodeBuildMCP__build_run_sim({
  projectPath: '/path/to/BulletJournalTodos.xcodeproj',
  scheme: 'BulletJournalTodos',
  simulatorName: 'iPad Pro 13-inch (M4)'
})
```

## Automated Tests (via simctl/MCP)

Core functionality tests that can be automated:

1. Build and launch on iPad simulator
2. Create tasks in LIFE and WORK focus areas
3. Toggle between focus areas, verify filtering
4. Complete/uncomplete tasks via checkbox
5. Test sheet: swipe dismiss, tap outside, submit
6. Switch focus while sheet open, verify task goes to correct area
7. Restart app, verify persistence
8. Dark mode: `xcrun simctl ui <uuid> appearance dark`
9. Landscape: rotation via simulator (can verify with describe_ui)
10. Verify reorder handles visible in UI hierarchy

## Manual Tests (Cannot Automate)

**Drag-to-reorder**: Requires long-press + drag gesture. Simctl limitation.

**Empty state deletion**: Requires swipe-left on row to reveal delete button. Simctl limitation.

**Split screen mode**: No simctl API. Test 50/50, 33/67, 67/33 splits. Verify UI not stretched, sheet presentation correct.

**Slide over mode**: No simctl API. Verify app remains usable with another app in slide over.

**Rotation with sheet open**: Can rotate via Cmd+Left/Right, but testing sheet behavior during rotation requires manual interaction. Verify sheet repositions correctly.

## UI Verification

**Colors** (use describe_ui or screenshots):
- Active toggle: blue
- Inactive toggle: gray
- "+ Create task" button: gray background, blue + icon

**Spacing** (check with describe_ui frame data):
- Week header: ~48px from top
- Focus toggle: ~88px from top
- Task list: ~129px from top
- Task row height: 52px

**Checkboxes**:
- Completed: `checkmark.square` icon
- Incomplete: `square` icon

**Animations**: Sheet slide-up, keyboard, scrolling (verify visually smooth)

## iPad-Specific

**Sheet padding** (implemented in AddTaskSheet.swift:17-25):
- iOS 26+: 24pt (vs 16pt iPhone)
- iOS 17-25: 20pt (vs 8pt iPhone)
- Implementation: `UIDevice.current.userInterfaceIdiom == .pad`

**Layout**: Verify via describe_ui that elements scale proportionally, no fixed widths causing stretching.

## Test Simulators

- iPad Pro 13-inch (M4) - largest screen
- iPad Pro 11-inch (M4) - medium
- iPad mini (A17 Pro) - smallest
- iPad Air 11-inch (M3) - standard

List available: `xcrun simctl list devices available | grep "iPad"`

## Known Automation Limitations

1. **Split screen** - No simctl commands for multitasking control
2. **Slide over** - Requires app switcher gestures
3. **Swipe-to-delete** - List row swipe gestures not supported

Verified via: `xcrun simctl help | grep -i "split\|multi\|window\|layout"` (no results)
