# View Modifiers

File paths relative to `Sources/SwiftUIExtension/`.

---

## GenericDialog

**File:** `View+Ext/View+GenericDialog.swift`

A custom modal dialog overlay with dark background, rounded container, and optional tap-outside-to-dismiss.

### genericDialog

Present any custom content as a centered dialog.

```swift
@State private var showDialog = false

ContentView()
    .genericDialog(isShowing: $showDialog, cancelOnTapOutside: true) {
        VStack(spacing: 16) {
            Text("Confirm Action")
                .font(.headline)
            Text("Are you sure?")
            HStack {
                Button("Cancel") { showDialog = false }
                Button("Confirm") { performAction() }
            }
        }
        .padding()
    }
```

### loadingDialog

A pre-built dialog with a circular progress indicator.

```swift
@State private var isProcessing = false

ContentView()
    .loadingDialog(isShowing: $isProcessing)
```

### progressDialog

A dialog showing a message and progress bar driven by Foundation's `Progress`.

```swift
@State private var showProgress = false
let progress = Progress(totalUnitCount: 100)

ContentView()
    .progressDialog(
        isShowing: $showProgress,
        message: "Uploading...",
        progress: progress
    )
```

---

## DroppableViewModifier

**File:** `ViewModifiers/DroppableViewModifier.swift`
**Platform:** iOS, macOS

### DropDelegate-based drop

Traditional drop using `DropDelegate`.

```swift
Text("Drop here")
    .modifier(DroppableViewModifier(
        isDisabled: false,
        supportedContentTypes: [.plainText],
        dropDelegate: myDropDelegate
    ))
```

### Transferable-based drop (iOS 16+, macOS 13+)

Modern drop with the `Transferable` protocol. Shows a "Drop your item here..." overlay when a drag hovers over the target.

```swift
MyView()
    .modifier(TransferableDroppableViewModifier(for: String.self) { items, location in
        handleDrop(items)
        return true
    })
```

---

## KeyboardObserverViewModifier

**File:** `ViewModifiers/KeyboardObserverViewModifer.swift`
**Platform:** iOS only

Observes keyboard show/hide events and updates a boolean binding.

```swift
@State private var isKeyboardShown = false

TextEditor(text: $text)
    .modifier(KeyboardObserverViewModifer(didShow: $isKeyboardShown))

if isKeyboardShown {
    Button("Dismiss") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
}
```

---

## GlassEffectModifier (Liquid Glass)

**File:** `ViewModifiers/LiquidGlassModifier.swift`
**Platform:** iOS 26+, macOS 26+, watchOS 26+

Applies iOS 26's Liquid Glass material effect with configurable shape and tint.

### GlassEffect options

| Effect | Description |
|--------|-------------|
| `.clear` | Transparent glass |
| `.regular` | Standard glass with opacity |
| `.clearInteractive` | Clear glass responding to interaction |
| `.regularInteractive` | Regular glass responding to interaction |

### GlassShape options

| Shape | Description |
|-------|-------------|
| `.none` | Adapts to container |
| `.rect` | Rectangle |
| `.roundedRect(cornerRadius:)` | Rounded rectangle |
| `.concentric` | Concentric corners (iOS 26, falls back to rounded) |
| `.capsule` | Pill shape |
| `.circle` | Circle |

```swift
// Rounded glass button
Text("Glass Button")
    .padding()
    .modifier(GlassEffectModifier(
        effect: .regular,
        shape: .capsule,
        tint: .blue
    ))

// Clear glass card
VStack { content }
    .modifier(GlassEffectModifier(
        effect: .clear,
        shape: .roundedRect(cornerRadius: 16)
    ))
```

---

## NavigationSubtitleModifier

**File:** `ViewModifiers/NavigationSubtitleModifier.swift`
**Platform:** iOS 26+, macOS 26+

Sets a navigation subtitle below the title.

```swift
ContentView()
    .modifier(NavigationSubtitleModifier("12 items"))
```

---

## ScenePhaseServices

**File:** `ViewModifiers/ScenePhaseServices.swift`

Routes app lifecycle events (`active`, `inactive`, `background`) to a list of `ApplicationService` conformers. Apply once at the app root.

### ApplicationService protocol

```swift
class AnalyticsService: ApplicationService {
    func becomeActive() {
        // Resume tracking
    }

    func resignActive() {
        // Pause tracking
    }

    func enterBackground() {
        // Flush events
    }

    func performTaskBeforeAppAppear() async {
        // Pre-launch setup
    }
}
```

### Usage

```swift
@main
struct MyApp: App {
    let analytics = AnalyticsService()
    let sync = SyncService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(ScenePhaseServices([analytics, sync]))
        }
    }
}
```

---

## ScrollViewOffsetReader

**File:** `ViewModifiers/ScrollViewOffsetReader.swift`

Tracks a view's scroll position within a named coordinate space.

```swift
@State private var scrollOffset: CGPoint = .zero

ScrollView {
    VStack {
        Text("Header")
            .modifier(ScrollViewOffsetReader(
                coordinateSpace: .named("scroll"),
                position: $scrollOffset
            ))
        // ... content
    }
}
.coordinateSpace(name: "scroll")

// Use scrollOffset.y to drive effects (e.g., collapse header)
```
