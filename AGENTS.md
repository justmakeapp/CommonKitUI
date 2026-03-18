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
- **OS version branching via `.modifier {}`** — Use the inline `@ViewBuilder` modifier to apply version-gated APIs without a separate ViewModifier. `if #available` works inside the closure. Prefer this over `.if()` for OS checks. See [View Extensions](.agents/docs/swiftui-view-extensions.md#modifierbody) for examples.

## ViewComponent Reference

- [Buttons](.agents/docs/buttons.md) — CloseButton, DebounceButton, PlusCircularButtonLabel
- [Text & Typography](.agents/docs/text-typography.md) — ExpandableText, MarqueeText, TruncableText, TypewriterView, CustomNavigationTitleView
- [Text Input](.agents/docs/text-input.md) — EditorView, EmojiTextField, DefaultTextFieldStyle
- [Layout & Containers](.agents/docs/layout-containers.md) — WrappingHStack, MasonryVStack, ZStackView
- [Progress & Status](.agents/docs/progress-status.md) — CustomProgressView, CheckmarkView, PageIndicator
- [Lists & Pagination](.agents/docs/lists-pagination.md) — LoadMore protocol, LoadMoreViewModifier, SectionHeader
- [Document & Web](.agents/docs/document-web.md) — DocumentPicker, ImagePicker, PdfKitView, WebView, ShareSheetView
- [Effects & Utilities](.agents/docs/effects-utilities.md) — AnimatedBgView, ShakeEffect, Clipboard, FeedbackManager, DismissAll

## SwiftUIExtension Reference

- [Binding, Animation & Transitions](.agents/docs/swiftui-binding-animation.md) — Binding.onChange/map/inverted/nilCoalescing, Animation.repeat(while:), custom transitions (fade, flip, cornerRadius)
- [View Extensions](.agents/docs/swiftui-view-extensions.md) — .if(), .isHidden(), .readSize(), .onDebounceTapGesture(), .onChangeDebounced(), .navigationDestination(using:), .sheet(using:), .alert(using:), .redacted(if:), platform-conditional buildView(for:)
- [View Modifiers](.agents/docs/swiftui-view-modifiers.md) — GenericDialog, loadingDialog, progressDialog, DroppableViewModifier, KeyboardObserver, GlassEffectModifier, NavigationSubtitle, ScenePhaseServices, ScrollViewOffsetReader
- [Button Styles & Utilities](.agents/docs/swiftui-buttons-styles.md) — PressEffectButtonStyle, RoundedPrimaryButtonStyle, AnyButtonStyle, KeyboardReadable, environment values (safeAreaInsets, isPreview), EdgeInsets helpers, Color platform init
