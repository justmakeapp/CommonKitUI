# Button Styles & Utilities

File paths relative to `Sources/SwiftUIExtension/`.

---

## AnyButtonStyle

**File:** `Buttons/ButtonStyle.swift`

A type-erased wrapper for `ButtonStyle`. Useful when you need to store or pass button styles dynamically.

```swift
let style: AnyButtonStyle = PressEffectButtonStyle().eraseToAnyButtonStyle()

Button("Tap") { }
    .buttonStyle(style)
```

---

## PressEffectButtonStyle

**File:** `Buttons/ButtonStyle.swift`

Adds a scale-down and opacity effect when the button is pressed. Animates with `.default` timing.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `pressedScale` | `0.9` | Scale factor when pressed |

**Pressed state:** scale to `pressedScale`, opacity to `0.6`.

```swift
// Using the static shorthand
Button("Submit") { save() }
    .buttonStyle(.pressEffect)

// Custom scale
Button("Delete") { delete() }
    .buttonStyle(PressEffectButtonStyle(pressedScale: 0.95))
```

---

## AnyPrimitiveButtonStyle

**File:** `Buttons/PrimitiveButtonStyle.swift`

A type-erased wrapper for `PrimitiveButtonStyle`. Useful for storing or injecting styles.

```swift
let style = BorderlessButtonStyle().eraseToAnyPrimitiveButtonStyle()
```

---

## RoundedPrimaryButtonStyle

**File:** `Buttons/RoundedPrimaryButtonStyle.swift`

A `ViewModifier` that styles a button as a full-width, tint-colored pill with white text. Apply with `.modifier()`.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `cornerRadius` | `8` | Corner radius of the background |

```swift
Button("Get Started") { onboard() }
    .modifier(RoundedPrimaryButtonStyle())

// Custom corner radius
Button("Continue") { next() }
    .modifier(RoundedPrimaryButtonStyle(cornerRadius: 16))
```

---

## KeyboardReadable

**File:** `KeyboardReadable.swift`
**Platform:** iOS only

A protocol providing Combine publishers for keyboard visibility and size. Conform your view or view model.

```swift
struct MyView: View, KeyboardReadable {
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack {
            TextField("Input", text: $text)
            if !isKeyboardVisible {
                BottomBar()
            }
        }
        .onReceive(keyboardPublisher) { visible in
            isKeyboardVisible = visible
        }
    }
}
```

---

## Environment Values

**File:** `EnvironmentValues/EnvironmentValues+Ext.swift`

### safeAreaInsets

Custom environment value for passing safe area insets down the view hierarchy.

```swift
// Set
ContentView()
    .environment(\.safeAreaInsets, EdgeInsets(top: 44, leading: 0, bottom: 34, trailing: 0))

// Read
@Environment(\.safeAreaInsets) private var safeAreaInsets
```

### isPreview

Flag to detect if running in SwiftUI preview mode.

```swift
// Set at preview level
ContentView()
    .environment(\.isPreview, true)

// Read
@Environment(\.isPreview) private var isPreview

var body: some View {
    if isPreview {
        MockDataView()
    } else {
        LiveDataView()
    }
}
```

---

## EdgeInsets Convenience Initializers

**File:** `EdgeInsets+Extension.swift`

```swift
// Uniform insets (same value on all sides)
let insets = EdgeInsets(16)
// → EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

// Horizontal + vertical
let insets = EdgeInsets(horizontal: 20, vertical: 12)
// → EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
```

---

## Color Platform Initializer

**File:** `Color+Ext.swift`

Creates a color that resolves differently per platform. Returns `nil` if the current platform has no matching closure.

```swift
let backgroundColor = Color(
    onMac: { .white },
    onPad: { .init(.systemGroupedBackground) },
    onPhone: { .init(.systemBackground) }
)
```

---

## ChartContent Modifier

**File:** `Charts+Ext/ChartContent+Ext.swift`
**Platform:** iOS 16+, macOS 13+

Inline `@ChartContentBuilder` modifier for chart content.

```swift
Chart {
    ForEach(data) { item in
        BarMark(x: .value("X", item.x), y: .value("Y", item.y))
    }
    .modifier { content in
        content.foregroundStyle(.blue)
    }
}
```
