import SwiftUI
import SwiftUIExtension

public struct CloseButton: View {
    let action: () -> Void

    private var config = Config()

    public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Group {
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, *) {
                Button(role: .close, action: buttonTapped)
            } else {
                Button(action: buttonTapped, label: {
                    if let size = config.labelSize {
                        buttonLabel
                            .frame(width: size.width, height: size.height)
                    } else {
                        buttonLabel
                    }

                })
            }
        }
        #if !os(watchOS)
        .keyboardShortcut(.cancelAction)
        #endif
        .modifier {
            if let buttonStyle = config.buttonStyle {
                $0.buttonStyle(buttonStyle)
            } else {
                $0
            }
        }
    }

    @ViewBuilder
    private var buttonLabel: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title)
            .imageScale(.medium)
            .foregroundColor(Color.secondary.opacity(0.6))
    }

    private func buttonTapped() {
        FeedbackManager.selectionChangedFeedback()

        action()
    }
}

public extension CloseButton {
    @MainActor
    struct Config {
        var labelSize: CGSize?
        var buttonStyle: AnyPrimitiveButtonStyle?
    }

    func labelSize(_ size: CGSize?) -> Self {
        transform { $0.config.labelSize = size }
    }

    func customButtonStyle(_ style: some PrimitiveButtonStyle) -> Self {
        transform { $0.config.buttonStyle = .init(style: style) }
    }
}

#Preview {
    NavigationStack {
        VStack {
            CloseButton {}
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton {}
            }
        }
    }
    #if os(macOS)
    .frame(width: 400, height: 300)
    #endif
}
