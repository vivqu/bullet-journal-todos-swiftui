# iPad Testing Guide

Reference for iPad compatibility testing. Use MCP XcodeBuildMCP tools for automation.

## Automated Tests

1. Build and launch on iPad simulator (iPad Pro 13-inch recommended)
2. Create tasks in LIFE and WORK focus areas
3. Toggle between focus areas, verify filtering
4. Complete/uncomplete tasks via checkbox
5. Test sheet: swipe dismiss, tap outside, submit
6. Switch focus while sheet open, verify task goes to correct area
7. Restart app, verify persistence
8. Dark mode (use `set_sim_appearance`)
9. Landscape rotation (verify with `describe_ui`)
10. Verify reorder handles visible in UI hierarchy

## Manual Tests (Cannot Automate)

**Drag-to-reorder**: Long-press + drag gesture. Simctl limitation.

**Empty state deletion**: Swipe-left on row. Simctl limitation.

**Split screen mode**: No simctl API. Test 50/50, 33/67, 67/33 splits.

**Slide over mode**: No simctl API. Verify app usable with slide over.

**Rotation with sheet open**: Sheet repositioning requires manual verification.

## UI Verification Specs

**Colors** (via describe_ui or screenshots):
- Active toggle: blue
- Inactive toggle: gray
- "+ Create task": gray background, blue + icon

**Spacing** (describe_ui frame data):
- Week header: ~48px from top
- Focus toggle: ~88px from top
- Task list: ~129px from top
- Task row height: 52px

**Checkboxes**:
- Completed: `checkmark.square` icon
- Incomplete: `square` icon

**Animations**: Sheet slide-up, keyboard, scrolling (visual verification)

## iPad-Specific Implementation

**Sheet padding** (AddTaskSheet.swift:17-25):
- iOS 26+: 24pt (vs 16pt iPhone)
- iOS 17-25: 20pt (vs 8pt iPhone)
- Detection: `UIDevice.current.userInterfaceIdiom == .pad`

**Layout**: Verify proportional scaling via describe_ui, no fixed widths.

## Recommended Test Devices

- iPad Pro 13-inch (M4) - largest
- iPad Pro 11-inch (M4) - medium
- iPad mini (A17 Pro) - smallest
- iPad Air 11-inch (M3) - standard

## Known Automation Limits

1. Split screen - no simctl multitasking API
2. Slide over - requires app switcher gestures
3. Swipe-to-delete - row swipe gestures unsupported
