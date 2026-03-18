## Overview

CommonKitUI is a cross-platform SwiftUI component library (iOS 16+, macOS 13+, visionOS 1+, watchOS 9+) with zero external dependencies. Uses Swift 6 language mode.

## Build

```bash
swift build                    # Debug build
swift build -c release         # Release build
```

No test target exists.

## Architecture

Four libraries with a linear dependency chain:

```
ViewComponent → SwiftUIExtension → UIKitExtension → CoreGraphicsExt
```

## Key Patterns

- **Cross-platform via `#if os(...)`** — Always guard platform-specific APIs.
- **Config structs with transform builders** — Components use inner `Config` structs with method-chaining configuration (e.g., `CustomProgressView(0.5).style(.circular).progressColor(.blue)`)

## ViewComponent Reference

- [Buttons](.agents/docs/buttons.md) — CloseButton, DebounceButton, PlusCircularButtonLabel
- [Text & Typography](.agents/docs/text-typography.md) — ExpandableText, MarqueeText, TruncableText, TypewriterView, CustomNavigationTitleView
- [Text Input](.agents/docs/text-input.md) — EditorView, EmojiTextField, DefaultTextFieldStyle
- [Layout & Containers](.agents/docs/layout-containers.md) — WrappingHStack, MasonryVStack, ZStackView
- [Progress & Status](.agents/docs/progress-status.md) — CustomProgressView, CheckmarkView, PageIndicator
- [Lists & Pagination](.agents/docs/lists-pagination.md) — LoadMore protocol, LoadMoreViewModifier, SectionHeader
- [Document & Web](.agents/docs/document-web.md) — DocumentPicker, ImagePicker, PdfKitView, WebView, ShareSheetView
- [Effects & Utilities](.agents/docs/effects-utilities.md) — AnimatedBgView, ShakeEffect, Clipboard, FeedbackManager, DismissAll
