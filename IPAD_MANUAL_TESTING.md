# iPad Manual Testing Checklist

## Automated Tests Completed ✅
- [x] Build and run on iPad Pro 13-inch simulator
- [x] Create multiple tasks in LIFE focus area
- [x] Switch to WORK focus area
- [x] Create multiple tasks in WORK focus area
- [x] Toggle between LIFE/WORK (verified correct task filtering)
- [x] Test task completion (checkbox toggle)
- [x] Test sheet behaviors (swipe dismiss, tap outside, submit)
- [x] Test sheet padding (improved for iPad)
- [x] Test dark mode
- [x] Test landscape orientation
- [x] Restart app and verify data persists

## Manual Tests Required 🔍

### 1. Drag-to-Reorder
**Steps:**
1. Open app on iPad simulator
2. Create 3+ tasks in LIFE
3. Long-press and drag a task to reorder
4. Verify sortOrder updates and persists
5. Repeat for WORK focus area

### 2. Empty State Testing
**Steps:**
1. Switch to WORK focus area
2. Swipe left on each task and tap Delete
3. Verify empty state shows only "+ Create task" button
4. Create a new task, verify it appears correctly

### 3. Focus Area Switching While Sheet Open
**Steps:**
1. Tap "+ Create task" to open sheet
2. While sheet is open, tap "WORK" toggle
3. Type a task name and submit
4. Verify task was created in WORK (not LIFE)

### 4. Split Screen Mode
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

### 5. Slide Over Mode
**Steps:**
1. Open BulletJournalTodos in full screen
2. Open another app (e.g., Notes)
3. Swipe from bottom to show app switcher
4. Drag Notes app to right edge for slide over
5. Verify:
   - BulletJournalTodos remains usable
   - Can create/complete tasks
   - Sheet presentation works correctly

### 6. Rotation Testing
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

## UI Polish Verification (from Task #22)
- [ ] Colors: blue for active toggle, gray button, blue circular +
- [ ] Spacing between components looks balanced on iPad
- [ ] Checkbox styling matches mockup
- [ ] Smooth animations (sheet, keyboard, scroll)

## iPad-Specific Verification
- [ ] Layout scales appropriately on larger screen
- [ ] UI doesn't look stretched or awkward
- [ ] Keyboard behavior and sheet presentation work well on iPad
