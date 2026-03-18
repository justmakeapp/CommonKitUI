# Text & Typography

File paths relative to `Sources/ViewComponent/`.

---

## ExpandableText

**File:** `Text/ExpandableText.swift`
**Platform:** All

Displays text truncated to a configurable line limit with a "more" button that expands to show the full content. Supports collapse-on-tap and gradient fade on the expand button.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.font(_)` | `.body` | Text font |
| `.foregroundColor(_)` | `.primary` | Text color |
| `.lineLimit(_)` | `3` | Lines shown when collapsed |
| `.moreButtonText(_)` | `"more"` | Expand button label |
| `.moreButtonFont(_)` | same as text | Expand button font |
| `.moreButtonColor(_)` | `.accentColor` | Expand button color |
| `.expandAnimation(_)` | `.default` | Expand/collapse animation |
| `.enableCollapse(_)` | `false` | Allow tapping text to collapse |
| `.trimMultipleNewlinesWhenTruncated(_)` | `true` | Remove double newlines when truncated |

**Sample:**

```swift
ExpandableText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
    .font(.subheadline)
    .lineLimit(2)
    .moreButtonText("Read more")
    .moreButtonColor(.blue)
    .enableCollapse(true)
```

---

## MarqueeText

**File:** `Text/MarqueeText.swift`
**Platform:** All

Horizontally scrolling text with fade edges. Only animates when the text is wider than the container. Uses `PlatformFont` (`UIFont` on iOS, `NSFont` on macOS).

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.makeCompact(_)` | `false` | Fit width to content instead of filling available space |

**Sample:**

```swift
// Scrolling song title
MarqueeText(
    text: "A Very Long Song Title That Doesn't Fit",
    font: .systemFont(ofSize: 16, weight: .medium),
    leftFade: 16,
    rightFade: 16,
    startDelay: 1.0
)

// Compact mode for inline usage
MarqueeText(
    text: "Long label text",
    font: .systemFont(ofSize: 14),
    leftFade: 8,
    rightFade: 8,
    startDelay: 0.5
)
.makeCompact()
```

---

## TruncableText

**File:** `Text/TruncableText.swift`
**Platform:** All

Text view that detects truncation and shows a custom expand button with a gradient fade overlay. Provide any view as the button label via the `@ViewBuilder`.

**Sample:**

```swift
@State private var isExpanded = false

TruncableText(Text("Long content here...")) {
    Button("Show more") {
        isExpanded = true
    }
    .font(.caption)
    .foregroundColor(.accentColor)
}
```

---

## TypewriterView

**File:** `Text/TypewriterViews/TypewriterView.swift`
**Platform:** iOS 16+, macOS 13+

Reveals text character-by-character with a configurable typing speed. Uses `AttributedString` internally — characters start transparent and become visible as the animation progresses.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.offsetBy(_)` | `0` | Skip first N characters (show them immediately) |
| `.onCompleted(_)` | `{}` | Callback when all characters are revealed |

**Sample:**

```swift
// Basic typewriter
TypewriterView(text: "Hello, welcome to the app!")

// Fast typing with completion handler
TypewriterView(text: "Processing complete.", typingDelay: .milliseconds(15))
    .onCompleted {
        showNextStep = true
    }

// Resume from an offset (first 10 chars shown instantly)
TypewriterView(text: "Continuing from where we left off...")
    .offsetBy(10)
```

---

## TypeWriterWithIndicatorView

**File:** `Text/TypewriterViews/TypeWriterWithIndicatorView.swift`
**Platform:** All

Cycles through an array of sentences with typewriter animation. Each sentence types out, pauses for 2 seconds, retracts, then advances to the next. Appends an animated dot indicator (●) to the text.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.onNextSentence(perform:)` | `{}` | Callback when advancing to next sentence |
| `.hapticFeedbackEnabled(_)` | `true` | Haptic feedback per character |
| `.canAnimate(_)` | `true` | Enable/disable the animation loop |

**Sample:**

```swift
TypeWriterWithIndicatorView(
    sentences: [
        "Transcribing your audio...",
        "Analyzing speech patterns...",
        "Almost done..."
    ]
)
.hapticFeedbackEnabled(false)
.onNextSentence {
    // track progress
}
```

---

## CustomNavigationTitleView

**File:** `CustomNavigationTitleView.swift`
**Platform:** All

A styled navigation title with `.title` font, `.semibold` weight, and leading alignment.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.lineLimit(_)` | `2` | Maximum number of lines |

**Sample:**

```swift
VStack(alignment: .leading) {
    CustomNavigationTitleView("My Documents")
        .lineLimit(1)
    // ... content
}
```
