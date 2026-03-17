**Note**: Save agent instructions to AGENTS.md files (this file), not CLAUDE.md.

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
