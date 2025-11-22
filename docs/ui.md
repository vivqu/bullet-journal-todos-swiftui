# UI Design Guidelines

High-level UI principles for the Bullet Journal Todos app. Specific values may change as the design evolves.

## Color Principles

**Use system colors for automatic light/dark mode support:**

- **Text**: `.primary`, `.secondary`, `.tertiary` (never `.black` or `.white`)
- **Backgrounds**: System backgrounds (`.background`, `.systemBackground`)
- **Accents**: `.blue` and other system accent colors (auto-adapt to dark mode)
- **Custom colors**: Must define dark mode variants

**General palette** (subject to change):
- Active states: Blue
- Inactive states: Gray/primary
- Interactive elements: Blue accents
- Backgrounds: System backgrounds

## Testing

Always test in both light and dark mode. Test on small (iPhone SE) and large (Pro Max) screens to verify layout scaling.

## Typography

Use system typography (`.body`, `.headline`, etc.) to ensure consistency and accessibility.

## Layout Principles

- Use system spacing and padding where possible
- Avoid hardcoded pixel values - use relative spacing
- Ensure touch targets are at least 44x44pt for accessibility
- SwiftUI auto-layout handles most spacing - only override when necessary
