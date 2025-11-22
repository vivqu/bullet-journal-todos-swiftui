# UI Design Guidelines

This document outlines the UI design principles and guidelines for the Bullet Journal Todos app.

## Color Guidelines

### Use System Colors for Light/Dark Mode Support

**IMPORTANT**: Always use SwiftUI's semantic system colors that automatically adapt to light and dark mode:

- **Text colors**: Use `.primary`, `.secondary`, `.tertiary` instead of `.black` or `.white`
- **Background colors**: Use system backgrounds (`.background`, `.systemBackground`) when possible
- **Accent colors**: `.blue` is acceptable as it adapts to dark mode automatically
- **Custom colors**: If using custom colors, ensure they have dark mode variants defined

### Current Color Palette

- **Active focus area toggle**: `.blue` (system color, adapts to dark mode)
- **Inactive focus area toggle**: `.primary` (system color, adapts to dark mode)
- **Create task button background**: `Color(white: 0.9)` (light gray)
- **Add task sheet "+" button**: `.blue` background with `.white` text
- **Task text**: `.primary` (system color, adapts to dark mode)
- **Checkbox**: `.primary` (system color, adapts to dark mode)

### Testing

Always test UI components in both light and dark mode to ensure proper visibility and contrast.

## Typography

- **Body text**: `.body` (system default)
- **Focus area toggle**: `.system(size: 17, weight: .regular)`
- **Week header**: `.body`

## Spacing

- **Main VStack spacing**: 20pt
- **Horizontal padding**: 20pt (standardized across components)
- **Task row vertical padding**: 6pt
- **Task row HStack spacing**: 12pt
- **Focus area toggle HStack spacing**: 4pt

## Component Sizing

- **Checkbox**: 24pt font size (SF Symbol)
- **Add task sheet "+" button**: 50x50pt circle
- **Create task button**: 16pt horizontal padding, 12pt vertical padding, 20pt corner radius
