# Document & Web

File paths relative to `Sources/ViewComponent/`.

---

## DocumentPicker

**File:** `DocumentPicker.swift`
**Platform:** iOS only

A `UIViewControllerRepresentable` wrapping `UIDocumentPickerViewController` for selecting files by content type.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.allowsMultipleSelection(_)` | `false` | Allow selecting multiple files |

**Sample:**

```swift
@State private var showPicker = false

Button("Import PDF") {
    showPicker = true
}
.sheet(isPresented: $showPicker) {
    DocumentPicker(
        contentTypes: [.pdf],
        didPickDocuments: { urls in
            handleImport(urls)
        }
    )
}

// Multiple file types and selection
DocumentPicker(
    contentTypes: [.pdf, .plainText, .audio],
    didPickDocuments: { urls in
        importFiles(urls)
    }
)
.allowsMultipleSelection(true)
```

---

## ImagePicker

**File:** `ImagePicker.swift`
**Platform:** iOS only

A `UIViewControllerRepresentable` wrapping `UIImagePickerController` for selecting photos from the library or capturing from the camera.

**Config:**

| Method | Default | Description |
|--------|---------|-------------|
| `.sourceType(_)` | `.photoLibrary` | `.photoLibrary`, `.camera`, or `.savedPhotosAlbum` |
| `.infoKey(_)` | `.originalImage` | Which image key to extract (`.originalImage`, `.editedImage`) |
| `.allowsEditing(_)` | `true` | Show crop/edit UI after selection |

**Sample:**

```swift
@State private var showCamera = false
@State private var selectedImage: UIImage?

Button("Take Photo") {
    showCamera = true
}
.sheet(isPresented: $showCamera) {
    ImagePicker(
        didPickImage: { image in
            selectedImage = image
        }
    )
    .sourceType(.camera)
    .allowsEditing(false)
}

// Full info dict callback
ImagePicker(
    didFinishPickingMediaWithInfo: { info in
        if let edited = info[.editedImage] as? UIImage {
            process(edited)
        }
    }
)
.sourceType(.photoLibrary)
.infoKey(.editedImage)
```

---

## PdfKitView

**File:** `PdfView/PdfView.swift`
**Platform:** iOS, macOS

A `UIViewRepresentable` / `NSViewRepresentable` wrapping PDFKit's `PDFView`. Auto-scales the PDF to fit the available space on iOS.

**Sample:**

```swift
// Display a local PDF
PdfKitView(url: Bundle.main.url(forResource: "guide", withExtension: "pdf")!)

// Display a downloaded PDF
PdfKitView(url: localFileURL)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
```

---

## WebView

**File:** `WebView/WebView.swift`
**Platform:** iOS, macOS (requires WebKit)

A SwiftUI web view with built-in loading spinner and error display. Uses `reloadRevalidatingCacheData` cache policy. Ignores safe area edges.

**Sample:**

```swift
// Basic web view
WebView(url: URL(string: "https://example.com"))

// In a sheet
.sheet(isPresented: $showWebView) {
    NavigationStack {
        WebView(url: termsURL)
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
    }
}
```

---

## WebViewController

**File:** `WebView/WebViewController.swift`
**Platform:** iOS only

A UIKit `UIViewController` subclass for displaying web content with loading state and error handling. Supports Escape key to dismiss. Use when you need UIKit navigation integration.

**Sample:**

```swift
// Push onto a UINavigationController
let webVC = WebViewController(url: URL(string: "https://example.com"))
navigationController?.pushViewController(webVC, animated: true)
```

---

## ShareSheetView

**File:** `ShareSheet/ShareSheetView.swift`
**Platform:** iOS only

A `UIViewControllerRepresentable` wrapping `UIActivityViewController` for the system share sheet. Pass any shareable items (strings, URLs, images).

**Sample:**

```swift
@State private var showShare = false

Button("Share") {
    showShare = true
}
.sheet(isPresented: $showShare) {
    ShareSheetView(activityItems: [
        "Check out this transcription!",
        URL(string: "https://example.com/share/123")!
    ])
}
```
