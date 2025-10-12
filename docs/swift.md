# Style guidelines

Do not force unwrap variables in Swift, which may suppress hidden errors. 
```
let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
```
Instead, we use the `guard let` pattern which is much more elegant and will
catch errors:
```
guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
    XCTFail("Expected a non-nil calendary date")
}
```