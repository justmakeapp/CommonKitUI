# Binding, Animation & Transition Extensions

File paths relative to `Sources/SwiftUIExtension/`.

---

## Binding Extensions

**File:** `Binding+Extension.swift`

### onChange

Wraps a binding to perform a side-effect whenever the value changes.

```swift
@State private var query = ""

TextField("Search", text: $query.onChange { newValue in
    viewModel.search(newValue)
})
```

### map / reverse map

Transforms a binding's value type with forward and reverse closures.

```swift
// Int binding → String binding
@State private var count = 0

TextField("Count", text: $count.map(
    { String($0) },
    { Int($0) ?? 0 }
))
```

### Optional handling

```swift
// Force unwrap an optional binding (crashes if nil)
@State private var name: String? = "Hello"
TextField("Name", text: $name.forceUnwrap())

// Nil-coalescing with a fallback
@State private var title: String? = nil
TextField("Title", text: $title.nilCoalescing(fallbackValue: "Untitled"))

// Safe optional binding with default
TextField("Name", text: .bindOptional($optionalName, ""))
```

### inverted

Returns a `Binding<Bool>` whose getter/setter are flipped.

```swift
@State private var isHidden = false

Toggle("Show details", isOn: $isHidden.inverted)
```

---

## Animation Extensions

**File:** `Animation+Ext.swift`

### repeat(while:autoreverses:)

Conditionally repeats an animation forever based on a boolean.

```swift
@State private var isAnimating = true

Circle()
    .scaleEffect(isAnimating ? 1.2 : 1.0)
    .animation(
        .easeInOut(duration: 0.8).repeat(while: isAnimating),
        value: isAnimating
    )
```

---

## Transitions

**Files:** `Transitions/AnyTransition+CustomTransition.swift`, `Transitions/AnyTransition+CornerRadius.swift`

### Directional slides

Slide-in transitions from each edge, with optional custom duration. Insertion animates in; removal is identity (no animation).

```swift
// Slide from left
Text("Hello")
    .transition(.flipFromLeft)

// Slide from bottom with duration
Text("Panel")
    .transition(.flipFromBottom(duration: 0.5))
```

**Available transitions:**

| Transition | Description |
|------------|-------------|
| `.fade` / `.fade(duration:)` | Opacity fade-in |
| `.flipFromLeft` / `.flipFromLeft(duration:)` | Slide from leading edge |
| `.flipFromRight` / `.flipFromRight(duration:)` | Slide from trailing edge |
| `.flipFromTop` / `.flipFromTop(duration:)` | Slide from top edge |
| `.flipFromBottom` / `.flipFromBottom(duration:)` | Slide from bottom edge |

### cornerRadius

Animates a rounded rectangle's corner radius during a transition.

```swift
RoundedRectangle(cornerRadius: 0)
    .transition(.cornerRadius(identity: 0, active: 20))
```
