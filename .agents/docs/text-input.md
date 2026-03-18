# Text Input

File paths relative to `Sources/ViewComponent/`.

---

## EditorView

**File:** `TextEditor/EditorView.swift`
**Platform:** iOS, macOS

A multi-line text editor with placeholder text and a keyboard toolbar containing a dismiss button. Uses `FocusState` for focus management. The placeholder appears in `.tertiary` color when text is empty.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.onDismissKeyboard(_)` | `{}` | Callback when keyboard dismiss button is tapped |

**Static:**

| Property | Value | Description |
|----------|-------|-------------|
| `EditorView.focusedFieldId` | `"ViewComponent.EditorView"` | Focus binding identifier |

**Sample:**

```swift
@FocusState private var focusedField: String?
@State private var notes = ""

EditorView(
    title: "Add your notes here...",
    text: $notes,
    focusedField: $focusedField
)
.onDismissKeyboard {
    // save draft
}
```

---

## EmojiTextField

**File:** `TextEditor/EmojiTextField.swift`
**Platform:** iOS, macOS

A text field that opens the emoji keyboard by default (iOS) with a hidden cursor. Text is centered. On macOS, uses a custom `FocusAwareTextField` that hides the cursor on focus.

**Sample:**

```swift
@State private var emoji = ""

EmojiTextField(text: $emoji, fontSize: 40)
    .frame(width: 60, height: 60)

// With placeholder
EmojiTextField(text: $emoji, placeholder: "😀", fontSize: 32)
```

---

## DefaultTextFieldStyle

**File:** `TextField/DefaultTextFieldStyle.swift`
**Platform:** All

A `ViewModifier` that applies a consistent rounded-rectangle border style to text fields. Fixed height of 46pt (scaled down on macOS to ~35pt), 12pt horizontal padding, 10pt corner radius.

**Sample:**

```swift
TextField("Enter name", text: $name)
    .modifier(DefaultTextFieldStyle(strokeColor: .gray))

// With a custom stroke color
TextField("Search...", text: $query)
    .modifier(DefaultTextFieldStyle(strokeColor: .blue.opacity(0.5)))
```
