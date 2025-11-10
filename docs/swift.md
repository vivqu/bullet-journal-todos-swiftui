# Style guidelines

## Scope

These style guidelines apply to **production code only**. The following code contexts are exempt from strict enforcement:

- **`#Preview` blocks** - Preview code is for development/debugging purposes and may use force unwrapping or other shortcuts for convenience
- **Test setup code** - Test scaffolding may use force unwrapping when the setup is guaranteed to succeed

However, even in exempt contexts, prefer safe patterns when practical.

## Force Unwrapping

Do not force unwrap variables in production Swift code, which may suppress hidden errors.

❌ **Bad (production code):**
```swift
let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
```

✅ **Good (production code):**
```swift
guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
    assertionFailure("Expected a non-nil calendar date")
    return calendar.startOfDay(for: today)
}
```

✅ **Acceptable (in #Preview only):**
```swift
#Preview {
    let container = try! ModelContainer(for: schema, configurations: [config])
    return ContentView()
        .modelContainer(container)
}
```