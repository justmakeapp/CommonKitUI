# Progress & Status

File paths relative to `Sources/ViewComponent/`.

---

## CustomProgressView

**File:** `ProgressView.swift`
**Platform:** All

A custom progress indicator with two styles: horizontal **bar** and **circular** ring. Animates changes with `.easeOut(duration: 0.25)`. Progress value is clamped to 0–1.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.style(_)` | `.bar` | `.bar` (horizontal) or `.circular` (ring) |
| `.progressColor(_)` | `.accentColor` | Fill color of the progress |
| `.useTintAsProgressColor(_)` | `true` | Use tint color instead of `progressColor` |
| `.trackColor(_)` | `.secondary.opacity(0.2)` | Background track color |
| `.cornerRadius(_)` | `8` | Corner radius (bar style) |
| `.lineWidth(_)` | `16` | Stroke width (circular style) |

**Sample:**

```swift
// Bar progress
CustomProgressView(value: bytesDownloaded, total: totalBytes)
    .progressColor(.blue)
    .trackColor(.blue.opacity(0.1))
    .frame(height: 8)

// Circular progress
CustomProgressView(0.75)
    .style(.circular)
    .progressColor(.green)
    .lineWidth(10)
    .frame(width: 80, height: 80)

// Using tint color
CustomProgressView(0.5)
    .style(.bar)
    .useTintAsProgressColor(true)
    .tint(.orange)
```

---

## CheckmarkView

**File:** `CheckmarkView.swift`
**Platform:** All

An animated success checkmark. On appear, a green circle stroke animates (1s, easeInOut), then a checkmark icon bounces in. The circle background fills with green at 20% opacity. No configuration — just size it with `.frame()`.

**Sample:**

```swift
// Success state
if isCompleted {
    CheckmarkView()
        .frame(width: 80, height: 80)
}

// Inside an alert-like view
VStack(spacing: 16) {
    CheckmarkView()
        .frame(width: 60, height: 60)
    Text("Upload Complete")
        .font(.headline)
}
```

---

## PageIndicator

**File:** `PageIndicator.swift`
**Platform:** All

A row of tappable dots indicating the current page. Selected dot scales to 1.1× with full tint color; unselected dots are 30% opacity.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.diameter(_)` | `8` | Dot size |
| `.spacing(_)` | `3` | Space between dots |

**Sample:**

```swift
@State private var currentPage = 0

TabView(selection: $currentPage) {
    ForEach(0..<5) { index in
        OnboardingPage(index: index)
            .tag(index)
    }
}
.tabViewStyle(.page(indexDisplayMode: .never))
.overlay(alignment: .bottom) {
    PageIndicator(numPages: 5, currentPage: $currentPage)
        .diameter(10)
        .spacing(6)
        .padding(.bottom, 20)
}
```
