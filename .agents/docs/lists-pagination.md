# Lists & Pagination

File paths relative to `Sources/ViewComponent/`.

---

## LoadMore (Protocol)

**File:** `List/LoadMore/LoadMore.swift`
**Platform:** All

A `@MainActor` protocol for adding infinite-scroll pagination to list view models. Conform your VM to this protocol, then apply `LoadMoreViewModifier` to list items.

**Required properties:**

| Property | Type | Description |
|----------|------|-------------|
| `pageSize` | `Int` (get/set) | Current page size |
| `isLoadMore` | `Bool` (get/set) | Currently loading more |
| `canLoadMore` | `Bool` (get/set) | Has more data to load |
| `reachEnd` | `Bool` (get/set) | Reached the end of data |

**Default implementations:**

| Member | Default | Description |
|--------|---------|-------------|
| `static pageSizeStep` | `10` | Increment per load-more |
| `loadMore()` | increments `pageSize` by `pageSizeStep`, sleeps 1.5s | Override for custom logic |
| `makeCanLoadMorePublisher(_)` | compares previous/current data count | Emits `true` when data grew and count >= step |

**Sample:**

```swift
@Observable
class DocumentListVM: LoadMore {
    var pageSize = 10
    var isLoadMore = false
    var canLoadMore = true
    var reachEnd = false

    var documents: [Document] = []

    func loadMore() async {
        isLoadMore = true
        pageSize += Self.pageSizeStep
        // Fetch logic here — the pageSize drives your query limit
        try? await Task.sleep(for: .seconds(1))
        isLoadMore = false
    }
}
```

---

## LoadMoreViewModifier

**File:** `List/LoadMore/LoadMoreViewModifier.swift`
**Platform:** All

A `ViewModifier` that triggers `loadMore()` when the last item in a list appears on screen. Apply it to each list row.

**Sample:**

```swift
List {
    ForEach(vm.documents) { doc in
        DocumentRow(doc)
            .modifier(
                LoadMoreViewModifier(
                    item: doc,
                    lastItem: vm.documents.last,
                    loadMoreObject: vm
                )
            )
    }
}
```

---

## LoadMoreIndicator

**File:** `List/LoadMore/LoadMoreViewModifier.swift`
**Platform:** All

A small view that shows a `ProgressView` while loading or "end of list" text when all data has been fetched.

**Init params:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `isLoadMore` | — | Show loading spinner |
| `reachEnd` | — | Show end-of-list text |
| `reachEndText` | `"All out"` | Text shown when `reachEnd` is true |

**Sample:**

```swift
List {
    ForEach(vm.documents) { doc in
        DocumentRow(doc)
            .modifier(LoadMoreViewModifier(item: doc, lastItem: vm.documents.last, loadMoreObject: vm))
    }

    // Footer
    LoadMoreIndicator(
        isLoadMore: vm.isLoadMore,
        reachEnd: vm.reachEnd,
        reachEndText: "No more documents"
    )
}
```

---

## SectionHeader

**File:** `List/SectionHeader.swift`
**Platform:** All

A styled section header with a title, optional subtitle, and optional trailing button. Title uses `.title2` bold by default. The trailing button builder defaults to `Spacer()`.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.titleFont(_)` | `.title2` | Title font |
| `.titleFontWeight(_)` | `.bold` | Title font weight |
| `.onTitleTapped(_)` | `nil` | Make title tappable |

**Sample:**

```swift
// Basic header
SectionHeader("Recent")

// With subtitle and trailing button
SectionHeader("Documents", subtitle: "12 items") {
    Button("See All") {
        showAll = true
    }
    .font(.subheadline)
}

// Tappable title with custom font
SectionHeader("Folders")
    .titleFont(.headline)
    .titleFontWeight(.semibold)
    .onTitleTapped {
        showFolderPicker = true
    }
```
