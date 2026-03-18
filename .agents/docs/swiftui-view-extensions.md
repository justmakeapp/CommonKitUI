# View Extensions

File paths relative to `Sources/SwiftUIExtension/`.

---

## Conditional Rendering

**File:** `View+Ext/View+Extension.swift`

### if(_:transform:)

Conditionally applies a view modifier.

```swift
Text("Hello")
    .if(isHighlighted) { view in
        view.foregroundColor(.yellow)
    }
```

### if(_:_:else:)

Applies one of two transforms based on a condition.

```swift
Text("Status")
    .if(isOnline,
        { $0.foregroundColor(.green) },
        else: { $0.foregroundColor(.gray) }
    )
```

### isHidden(_:remove:)

Hides or completely removes a view from the hierarchy.

```swift
// Hidden but still in layout
Text("Secret").isHidden(true)

// Removed entirely from view hierarchy
Text("Secret").isHidden(true, remove: true)
```

---

## Platform-Conditional Building

**Files:** `View+Ext/View+Extension.swift`, `ViewModifier+Ext.swift`, `ToolbarContent+Ext.swift`

### BuildPlatform OptionSet

Use `buildView(for:content:)` to render views only on specific platforms.

```swift
// Only show on iPad
buildView(for: .iPad) {
    SidebarView()
}

// Show on iPhone and iPad
buildView(for: [.iPhone, .iPad]) {
    MobileLayout()
}
```

**Available platforms:** `.iPad`, `.iPhone`, `.mac`, `.macCatalyst`, `.watch`

### Toolbar helpers (iOS)

```swift
// Toolbar content only on iPad
buildPadView {
    ToolbarItem { SortButton() }
}

// Only on iPhone
buildPhoneView {
    ToolbarItem { CompactButton() }
}

// iPhone and iPad (not Catalyst)
buildPhoneAndPadView {
    ToolbarItem { MobileAction() }
}

// Only on Mac/Catalyst
buildMacView {
    ToolbarItem { DesktopAction() }
}
```

---

## Size Reading

**File:** `View+Ext/View+Extension.swift`

### readSize (binding)

Reads a view's size into a binding.

```swift
@State private var contentSize: CGSize = .zero

Text("Measure me")
    .readSize($contentSize)
```

### readSize (callback)

Reads a view's size via a callback.

```swift
Text("Measure me")
    .readSize { size in
        print("Width: \(size.width), Height: \(size.height)")
    }
```

---

## Debounced Tap Gesture

**File:** `View+Ext/View+DebounceTapGesture.swift`

Prevents rapid double-taps on any view. Default debounce is 1 second.

```swift
Text("Tap me")
    .onDebounceTapGesture {
        performAction()
    }

// Custom debounce time
Image(systemName: "heart")
    .onDebounceTapGesture(debounceTime: .milliseconds(500)) {
        toggleFavorite()
    }
```

---

## Debounced onChange

**File:** `View+Ext/View+OnChangeDebounced.swift`
**Platform:** iOS 17+, macOS 14+, watchOS 10+

Debounces value changes with an async task. Cancels the previous pending action when the value changes again within the debounce window.

```swift
@State private var searchQuery = ""

TextField("Search", text: $searchQuery)
    .onChangeDebounced(of: searchQuery, for: .milliseconds(300)) { oldValue, newValue in
        await viewModel.search(newValue)
    }

// With shared task binding for external cancellation
@State private var searchTask: Task<Void, Never>?

TextField("Search", text: $searchQuery)
    .onChangeDebounced(of: searchQuery, for: .milliseconds(300), task: $searchTask) { _, newValue in
        await viewModel.search(newValue)
    }
```

---

## Navigation Destination (Optional Binding)

**File:** `View+Ext/View+Navigation.swift`
**Platform:** iOS 16+, macOS 13+

Drives a navigation destination from an optional value. Dismissing the destination sets the value back to `nil`.

```swift
@State private var selectedItem: Item?

List(items) { item in
    Button(item.title) { selectedItem = item }
}
.navigationDestination(using: $selectedItem) { item in
    ItemDetailView(item: item)
}
```

---

## Presentable (Alert / Sheet from Optional)

**File:** `View+Ext/View+Presentable.swift`

Present alerts and sheets driven by optional bindings — the presentation dismisses when the value becomes `nil`.

### Alert from optional

```swift
@State private var errorMessage: String?

ContentView()
    .alert(using: $errorMessage) { message in
        Alert(
            title: Text("Error"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
```

### Alert with actions (iOS 15+)

```swift
@State private var deleteItem: Item?

ContentView()
    .alert(using: $deleteItem, title: { $0.name }, content: { item in
        Button("Delete", role: .destructive) { viewModel.delete(item) }
        Button("Cancel", role: .cancel) { }
    }, message: { item in
        Text("Are you sure you want to delete \(item.name)?")
    })
```

### Sheet from optional

```swift
@State private var editingItem: Item?

ContentView()
    .sheet(using: $editingItem) { item in
        EditItemView(item: item)
    }
```

---

## Redacted

**File:** `View+Ext/View+Redacted.swift`

Conditionally applies the `.placeholder` redaction effect.

```swift
VStack {
    Text(user.name)
    Text(user.email)
}
.redacted(if: isLoading)
```

---

## Simultaneous Gesture (Conditional)

**File:** `View+Ext/View+Extension.swift`

Conditionally attaches a simultaneous gesture.

```swift
ScrollView {
    content
}
.simultaneousGesture(dragGesture, enabled: isDragEnabled)
```

---

## Transform / Modifier Helpers

**File:** `View+Ext/View+Extension.swift`

### transform(_:)

Mutates the view inline via a closure.

```swift
MyView()
    .transform { $0.someProperty = newValue }
```

### modifier(body:)

Inline `@ViewBuilder`-based modifier. Because the closure is a `@ViewBuilder`, you can use `if #available` checks inside it — this is the primary way to apply OS-version-gated APIs without creating a separate `ViewModifier` struct.

**Signature:**
```swift
func modifier<ModifiedContent: View>(
    @ViewBuilder body: (_ content: Self) -> ModifiedContent
) -> ModifiedContent
```

**Basic usage:**

```swift
Text("Hello")
    .modifier { content in
        content.padding().background(.blue)
    }
```

**OS version branching — apply new APIs with fallback:**

```swift
// Apply iOS 17+ typesettingLanguage, fall back to plain text
Text(title)
    .modifier { content in
        if #available(iOS 17.0, macOS 14.0, *) {
            content.typesettingLanguage(.init(languageCode: .japanese))
        } else {
            content
        }
    }
```

```swift
// Use scrollTargetBehavior on iOS 17+, plain ScrollView on older
ScrollView(.horizontal) {
    LazyHStack { items }
}
.modifier { content in
    if #available(iOS 17.0, macOS 14.0, *) {
        content.scrollTargetBehavior(.viewAligned)
    } else {
        content
    }
}
```

```swift
// iOS 16.4+ presentationCornerRadius, no-op on older
sheet
    .modifier { content in
        if #available(iOS 16.4, *) {
            content.presentationCornerRadius(20)
        } else {
            content
        }
    }
```

```swift
// iOS 26 Liquid Glass toolbar, standard toolbar on older
NavigationStack {
    ContentView()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add", systemImage: "plus") { add() }
            }
        }
        .modifier { content in
            if #available(iOS 26.0, *) {
                content.toolbarStyle(.glass)
            } else {
                content
            }
        }
}
```

```swift
// Combine multiple version checks in a chain
List(items) { item in
    ItemRow(item: item)
}
.modifier { content in
    if #available(iOS 17.0, macOS 14.0, *) {
        content.scrollContentBackground(.hidden)
    } else {
        content
    }
}
.modifier { content in
    if #available(iOS 16.0, macOS 13.0, *) {
        content.scrollDismissesKeyboard(.interactively)
    } else {
        content
    }
}
```

```swift
// SearchableModifier with iOS 17+ token support
TextField("Search", text: $query)
    .modifier { content in
        if #available(iOS 17.0, *) {
            content.searchable(text: $query, tokens: $tokens) { token in
                Label(token.name, systemImage: token.icon)
            }
        } else {
            content.searchable(text: $query)
        }
    }
```

**Why use `modifier(body:)` instead of `.if()`?**

`.if()` takes a `Bool`, so it cannot handle `#available` checks (which are not boolean expressions). The `modifier(body:)` closure is a `@ViewBuilder`, so `if #available` works naturally inside it. Use `.if()` for runtime booleans, use `.modifier {}` for compile-time OS availability.
