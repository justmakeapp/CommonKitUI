# Buttons

File paths relative to `Sources/ViewComponent/`.

---

## CloseButton

**File:** `Buttons/CloseButton.swift`
**Platform:** All (iOS renders icon, macOS renders text)

A platform-aware close/dismiss button with keyboard shortcut and haptic feedback. On iOS 26+ uses `Button(role: .close)`, older iOS shows `xmark.circle.fill` icon, macOS shows text label.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.title(_)` | `"Close"` | Button title (macOS text / accessibility) |
| `.labelSize(_)` | `nil` | Optional fixed size for the button |
| `.customButtonStyle(_)` | `nil` | Custom `PrimitiveButtonStyle` |

**Sample:**

```swift
// Basic usage — dismiss a sheet
CloseButton {
    dismiss()
}

// Custom title and fixed size
CloseButton {
    dismiss()
}
.title("Done")
.labelSize(CGSize(width: 44, height: 44))
```

---

## DebounceButton

**File:** `Buttons/DebounceButton.swift`
**Platform:** All

A button that prevents rapid double-taps by disabling itself for a configurable debounce interval. Includes optional haptic feedback on tap.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.debounceTime(_)` | `.seconds(1)` | Cooldown period between taps |
| `.disabledHapticFeedback(_)` | `false` | Set `true` to disable haptics |

**Sample:**

```swift
// Prevent double-submit
DebounceButton(
    action: {
        await viewModel.save()
    },
    label: {
        Text("Save")
    }
)
.debounceTime(.milliseconds(500))

// Without haptic feedback
DebounceButton(action: { viewModel.delete() }) {
    Label("Delete", systemImage: "trash")
}
.disabledHapticFeedback()
```

---

## PlusCircularButtonLabel

**File:** `Buttons/PlusCircularButtonLabel.swift`
**Platform:** All

A pre-styled 48×48 circular button label with a white "+" icon and layered shadow. Use as the `label` of a `Button`.

**Sample:**

```swift
Button {
    showNewItemSheet = true
} label: {
    PlusCircularButtonLabel()
}
```
