//
//  ImagePicker.swift
//
//
//  Created by longvu on 17/08/2022.
//

#if os(iOS)
    import SwiftUI
    import UIKit

    public struct ImagePicker: UIViewControllerRepresentable {
        struct Configuration {
            var allowsEditing = true
            var sourceType: UIImagePickerController.SourceType = .photoLibrary
            var infoKey: UIImagePickerController.InfoKey = .originalImage
            var didPickImage: ((UIImage) -> Void)?
            var didFinishPickingMediaWithInfo: ([UIImagePickerController.InfoKey: Any]) -> Void = { _ in }
        }

        private var config: Configuration

        @Environment(\.presentationMode) private var presentationMode

        public init(
            didPickImage: ((UIImage) -> Void)? = nil,
            didFinishPickingMediaWithInfo: @escaping ([UIImagePickerController.InfoKey: Any]) -> Void = { _ in }
        ) {
            config = .init(
                didPickImage: didPickImage,
                didFinishPickingMediaWithInfo: didFinishPickingMediaWithInfo
            )
        }

        public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>)
            -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = config.allowsEditing
            imagePicker.sourceType = config.sourceType
            imagePicker.delegate = context.coordinator

            return imagePicker
        }

        public func updateUIViewController(
            _ picker: UIImagePickerController,
            context _: UIViewControllerRepresentableContext<ImagePicker>
        ) {
            if config.allowsEditing != picker.allowsEditing {
                picker.allowsEditing = config.allowsEditing
            }

            if config.sourceType != picker.sourceType {
                picker.sourceType = config.sourceType
            }
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            var parent: ImagePicker

            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            public func imagePickerController(
                _: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
            ) {
                if let didPickImage = parent.config.didPickImage,
                   let image = info[parent.config.infoKey] as? UIImage {
                    didPickImage(image)
                }
                parent.config.didFinishPickingMediaWithInfo(info)

                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    // MARK: - API

    public extension ImagePicker {
        func sourceType(_ value: UIImagePickerController.SourceType) -> Self {
            return transform { $0.config.sourceType = value }
        }

        func infoKey(_ infoKey: UIImagePickerController.InfoKey) -> Self {
            return transform { $0.config.infoKey = infoKey }
        }

        func allowsEditing(_ value: Bool) -> Self {
            return transform { $0.config.allowsEditing = value }
        }
    }

#endif
