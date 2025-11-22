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
9. Rotation: Verify layout via `describe_ui` in portrait/landscape
10. Verify reorder handles present in UI (actual reordering requires manual drag gesture)

## Manual Tests (Cannot Automate)

**Split screen mode**: No simctl API. Test 50/50, 33/67, 67/33 splits. Verify UI not stretched, sheet works.

**Slide over mode**: No simctl API. Verify app usable with slide over.

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
