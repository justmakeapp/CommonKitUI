# Effects & Utilities

File paths relative to `Sources/ViewComponent/`.

---

## AnimatedBgView

**File:** `AnimatedBgView.swift`
**Platform:** All

A `ViewModifier` that continuously pans a background view (e.g., an image) with a configurable speed and direction. Bounces at the edges. Only animates if the background is sufficiently larger than the screen.

**Init params:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `timeInterval` | `0.1` | Timer tick interval in seconds |
| `sign` | `-1` | Initial direction (`-1` = up/left, `1` = down/right) |
| `step` | `3` | Pixels moved per tick |

**Sample:**

```swift
VStack {
    Text("Welcome")
        .font(.largeTitle)
}
.modifier(AnimatedBgView {
    Image("onboarding-bg")
        .resizable()
        .scaledToFill()
})
```

---

## ShakeEffect

**File:** `ShakeEffect.swift`
**Platform:** All

A `GeometryEffect` that produces a horizontal shake animation using a sine wave. Drive it with `withAnimation` by toggling the `animatableData` from 0 to 1.

**Init params:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `amount` | `10` | Horizontal shake distance in points |
| `shakesPerUnit` | `3` | Number of oscillations per animation cycle |
| `animatableData` | — | Animation progress value (0→1) |

**Sample:**

```swift
@State private var shakeAttempts: CGFloat = 0

TextField("Password", text: $password)
    .modifier(ShakeEffect(
        amount: 10,
        shakesPerUnit: 3,
        animatableData: shakeAttempts
    ))

// Trigger on invalid input
Button("Login") {
    if !isValid {
        withAnimation(.linear(duration: 0.4)) {
            shakeAttempts += 1
        }
    }
}
```

---

## DeviceShakeViewModifier

**File:** `DeviceShakeViewModifier.swift`
**Platform:** iOS only

A `ViewModifier` that detects physical device shake gestures and fires a callback. Extends `UIWindow` to post a notification on `.motionShake`.

**Sample:**

```swift
Text("Shake to undo")
    .modifier(DeviceShakeViewModifier {
        showUndoAlert = true
    })
```

---

## CustomEmptyView

**File:** `CustomEmptyView.swift`
**Platform:** All

A styled empty-state view with an SF Symbol icon, title, and optional description. Use for lists, search results, or any screen with no content.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.symbolRenderingMode(_)` | `nil` | SF Symbol rendering mode |
| `.titleColor(_)` | `.secondary` | Title text color |

**Sample:**

```swift
// Basic empty state
if items.isEmpty {
    CustomEmptyView(
        "No Transcriptions",
        systemImage: "waveform",
        description: Text("Record or import audio to get started.")
    )
}

// With custom rendering
CustomEmptyView("No Results", systemImage: "magnifyingglass")
    .symbolRenderingMode(.hierarchical)
    .titleColor(.primary)
```

---

## HiddenNavigationBarHostingViewController

**File:** `HiddenNavigationBarHostingViewController.swift`
**Platform:** iOS only

A `UIHostingController` subclass that automatically hides the navigation bar on appear and restores it on disappear. Zero configuration.

**Sample:**

```swift
// Use in UIKit navigation
let swiftUIView = MyFullScreenView()
let hostingVC = HiddenNavigationBarHostingViewController(rootView: swiftUIView)
navigationController?.pushViewController(hostingVC, animated: true)
```

---

## FeedbackManager

**File:** `FeedbackManager.swift`
**Platform:** All

A static utility for triggering platform-appropriate haptic feedback. On iOS uses `UISelectionFeedbackGenerator`, on macOS uses `NSHapticFeedbackManager`.

**Sample:**

```swift
Button("Select") {
    FeedbackManager.selectionChangedFeedback()
    selectedItem = item
}
```

---

## Clipboard

**File:** `Clipboard.swift`
**Platform:** All

A static utility for copying text to the system clipboard. On iOS uses `UIPasteboard`, on macOS uses `NSPasteboard`.

**Sample:**

```swift
Button("Copy") {
    Clipboard.write(transcription.text)
}
```

---

## DismissAll

**File:** `DismissAll.swift`
**Platform:** All

An `ObservableObject` that coordinates dismissing all presented sheets/modals. Call `trigger()` to request dismissal (async, returns when `complete()` is called). Observe `id` to react to dismissal requests.

**Sample:**

```swift
// Root view
@StateObject private var dismissAll = DismissAll()

NavigationStack {
    ContentView()
}
.environment(dismissAll)

// Deep child view — trigger dismiss all
Button("Close Everything") {
    Task {
        await dismissAll.trigger()
    }
}

// Intermediate sheet — react to dismissal
.onChange(of: dismissAll.id) {
    dismiss()
    dismissAll.complete()
}
```
