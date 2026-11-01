# Layout & Containers

File paths relative to `Sources/ViewComponent/`.

---

## WrappingHStack

**File:** `WrappingHStack.swift`
**Platform:** iOS 16+, macOS 13+

A `Layout`-conforming horizontal stack that wraps children to the next line when they exceed the available width. Supports configurable spacing and alignment. Uses hash-based caching for layout performance.

**Init params:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `alignment` | `.center` | Alignment guide for subviews |
| `horizontalSpacing` | `nil` (system default) | Space between items in a row |
| `verticalSpacing` | `nil` (system default) | Space between rows |
| `fitContentWidth` | `false` | If `true`, shrinks width to fit content instead of filling available space |

**Sample:**

```swift
// Tag cloud
WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
    ForEach(tags, id: \.self) { tag in
        Text(tag)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.blue.opacity(0.1))
            .cornerRadius(16)
    }
}

// Fit content width (e.g., inside a centered container)
WrappingHStack(alignment: .leading, horizontalSpacing: 4, fitContentWidth: true) {
    ForEach(badges, id: \.self) { badge in
        BadgeView(badge)
    }
}
```

---

## MasonryVStack

**File:** `MasonryVStack.swift`
**Platform:** All

A `Layout`-conforming Pinterest/masonry-style vertical layout. Items are distributed across columns, always placed in the shortest column to balance heights.

**Init params:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `columns` | `2` | Number of columns |
| `spacing` | `8.0` | Spacing between items (both horizontal and vertical) |

**Sample:**

```swift
// Two-column photo grid
ScrollView {
    MasonryVStack(columns: 2, spacing: 12) {
        ForEach(photos) { photo in
            AsyncImage(url: photo.url)
                .aspectRatio(photo.aspectRatio, contentMode: .fit)
                .cornerRadius(8)
        }
    }
    .padding()
}

// Three-column card layout
MasonryVStack(columns: 3, spacing: 8) {
    ForEach(cards) { card in
        CardView(card: card)
    }
}
```

---

## ZStackView

**File:** `ZStackView.swift`
**Platform:** All

A stacked card deck where cards scale down and offset as they go deeper. The top card is interactive; background cards are disabled. Useful for swipeable card interfaces (flashcards, onboarding, etc.).

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.seed(_)` | `0.13` | Scale reduction factor per card level |
| `.maxVisibleItemCount(_)` | `3` | Max cards visible in the stack |
| `.itemSpacing(_)` | `30` | Vertical offset between cards |
| `.cardOffset(_)` | built-in | Custom `(CardOffsetInfo) -> CGSize` for card positioning |

**Sample:**

```swift
@State private var topIndex = 0

// Basic card stack
ZStackView(numberOfViews: items.count, topItemIndex: $topIndex) { index in
    VStack {
        Text(items[index].title)
            .font(.title)
        Text(items[index].description)
            .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: 300)
    .background(.regularMaterial)
    .cornerRadius(16)
}

// Customized stack
ZStackView(numberOfViews: 5, topItemIndex: $topIndex) { index in
    FlashcardView(card: cards[index])
}
.maxVisibleItemCount(4)
.itemSpacing(20)
.seed(0.08)
```
