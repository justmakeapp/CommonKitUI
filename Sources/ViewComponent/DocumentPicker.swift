//
//  DocumentPicker.swift
//
//
//  Created by Thanh Duy Truong on 06/12/2022.
//

#if os(iOS)
    import SwiftUI
    import UniformTypeIdentifiers

    public struct DocumentPicker: UIViewControllerRepresentable {
        private struct Configuration {
            var contentTypes: [UTType]
            var allowsMultipleSelection: Bool = false
            var didPickDocuments: (_ urls: [URL]) -> Void
        }

        private var config: Configuration

        public init(
            contentTypes: [UTType],
            didPickDocuments: @escaping ([URL]) -> Void = { _ in }
        ) {
            config = .init(
                contentTypes: contentTypes,
                didPickDocuments: didPickDocuments
            )
        }

        public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: config.contentTypes)
            pickerController.allowsMultipleSelection = config.allowsMultipleSelection
            pickerController.delegate = context.coordinator
            return pickerController
        }

        public func updateUIViewController(_ controller: UIDocumentPickerViewController, context _: Context) {
            if controller.allowsMultipleSelection != config.allowsMultipleSelection {
                controller.allowsMultipleSelection = config.allowsMultipleSelection
            }
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        public final class Coordinator: NSObject, UIDocumentPickerDelegate {
            var parent: DocumentPicker

            init(_ parent: DocumentPicker) {
                self.parent = parent
            }

            public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                parent.config.didPickDocuments(urls)
            }
        }
    }

    public extension DocumentPicker {
        func allowsMultipleSelection(_ value: Bool) -> Self {
            then { $0.config.allowsMultipleSelection = value }
        }
    }
#endif
