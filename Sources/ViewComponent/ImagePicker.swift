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

        private var configuration: Configuration

        @Environment(\.presentationMode) private var presentationMode

        public init(
            didPickImage: ((UIImage) -> Void)? = nil,
            didFinishPickingMediaWithInfo: @escaping ([UIImagePickerController.InfoKey: Any]) -> Void = { _ in }
        ) {
            configuration = .init(
                didPickImage: didPickImage,
                didFinishPickingMediaWithInfo: didFinishPickingMediaWithInfo
            )
        }

        public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>)
            -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = configuration.allowsEditing
            imagePicker.sourceType = configuration.sourceType
            imagePicker.delegate = context.coordinator

            return imagePicker
        }

        public func updateUIViewController(
            _ picker: UIImagePickerController,
            context _: UIViewControllerRepresentableContext<ImagePicker>
        ) {
            if configuration.allowsEditing != picker.allowsEditing {
                picker.allowsEditing = configuration.allowsEditing
            }

            if configuration.sourceType != picker.sourceType {
                picker.sourceType = configuration.sourceType
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
                if let didPickImage = parent.configuration.didPickImage,
                   let image = info[parent.configuration.infoKey] as? UIImage {
                    didPickImage(image)
                }
                parent.configuration.didFinishPickingMediaWithInfo(info)

                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    // MARK: - API

    public extension ImagePicker {
        func sourceType(_ value: UIImagePickerController.SourceType) -> Self {
            return then { $0.configuration.sourceType = value }
        }

        func infoKey(_ infoKey: UIImagePickerController.InfoKey) -> Self {
            return then { $0.configuration.infoKey = infoKey }
        }

        func allowsEditing(_ value: Bool) -> Self {
            return then { $0.configuration.allowsEditing = value }
        }
    }

#endif
