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
                Button(action: buttonTapped) {
                    if let size = config.labelSize {
                        buttonLabel
                            .frame(width: size.width, height: size.height)
                    } else {
                        buttonLabel
                    }
                }
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
        #if os(macOS)
            Text(config.title)
        #endif

        #if os(iOS)
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .imageScale(.medium)
                .foregroundColor(Color.secondary.opacity(0.6))
        #endif
    }

    private func buttonTapped() {
        FeedbackManager.selectionChangedFeedback()

        action()
    }
}

public extension CloseButton {
    @MainActor
    struct Config {
        var title: String = "Close"
        var labelSize: CGSize?
        var buttonStyle: AnyPrimitiveButtonStyle?
    }

    func title(_ value: String) -> Self {
        transform { $0.config.title = value }
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
