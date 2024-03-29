import Combine
import SwiftUI

public struct GenericDialog<DialogContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    let cancelOnTapOutside: Bool
    let cancelAction: (() -> Void)?
    let dialogContent: DialogContent
    @Environment(\.colorScheme) private var colorScheme

    public init(
        isShowing: Binding<Bool>,
        cancelOnTapOutside: Bool,
        cancelAction: (() -> Void)?,
        @ViewBuilder dialogContent: () -> DialogContent
    ) {
        _isShowing = isShowing
        self.cancelOnTapOutside = cancelOnTapOutside
        self.cancelAction = cancelAction
        self.dialogContent = dialogContent()
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.3))
                    .onTapGesture {
                        if cancelOnTapOutside {
                            cancelAction?()
                            isShowing = false
                        }
                    }

                ZStack {
                    dialogContent
                        .background(RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(bgColor))
                }.padding(40)
            }
        }
        .ignoresSafeArea()
        .animation(.linear, value: isShowing)
    }

    private var bgColor: Color {
        switch colorScheme {
        case .light:
            return .white
        case .dark:
            return Color(red: 0.17, green: 0.17, blue: 0.18)
        @unknown default:
            return .white
        }
    }
}

public extension View {
    func genericDialog(
        isShowing: Binding<Bool>,
        cancelOnTapOutside: Bool = false,
        cancelAction: (() -> Void)? = nil,
        @ViewBuilder dialogContent: @escaping () -> some View
    ) -> some View {
        self.modifier(GenericDialog(
            isShowing: isShowing,
            cancelOnTapOutside: cancelOnTapOutside,
            cancelAction: cancelAction,
            dialogContent: dialogContent
        ))
    }
}

public extension View {
    @available(iOS 15.0, macOS 12.0, *)
    func loadingDialog(
        isShowing: Binding<Bool>,
        cancelOnTapOutside: Bool = false,
        cancelAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(GenericDialog(
            isShowing: isShowing,
            cancelOnTapOutside: cancelOnTapOutside,
            cancelAction: cancelAction,
            dialogContent: {
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.large)
                }
                .padding()
            }
        ))
    }

    func progressDialog(
        isShowing: Binding<Bool>,
        message: String,
        progress: Progress
    ) -> some View {
        self.genericDialog(isShowing: isShowing, cancelOnTapOutside: false) {
            HStack(spacing: 10) {
                if progress.isIndeterminate {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ProgressView(value: Float(progress.completedUnitCount) / Float(progress.totalUnitCount))
                        .progressViewStyle(CircularProgressViewStyle())
                }
                Text(message)
            }.padding()
        }
    }
}
