import SwiftUI

public struct CloseButton: View {
    let action: () -> Void

    private var config = Config()

    public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: {
            FeedbackManager.selectionChangedFeedback()

            action()
        }, label: {
            if let size = config.labelSize {
                buttonLabel
                    .frame(width: size.width, height: size.height)
            } else {
                buttonLabel
            }

        })
        .buttonStyle(.plain)
        #if !os(watchOS)
            .keyboardShortcut(.cancelAction)
        #endif
    }

    @ViewBuilder
    private var buttonLabel: some View {
        Group {
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, *) {
                #if compiler(>=6.2)
                    Image(systemName: "xmark")
                        .font(.title3)
                        .imageScale(.medium)
                        .foregroundColor(Color.primary)
                #else
                    beforeXcode26ButtonLabel
                #endif
            } else {
                beforeXcode26ButtonLabel
            }
        }
    }

    private var beforeXcode26ButtonLabel: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title)
            .imageScale(.medium)
            .foregroundColor(Color.secondary.opacity(0.6))
    }
}

public extension CloseButton {
    struct Config {
        var labelSize: CGSize?
    }

    func labelSize(_ size: CGSize?) -> some View {
        transform { $0.config.labelSize = size }
    }
}

#Preview {
    NavigationStack {
        VStack {
            CloseButton {}
        }
        .toolbar {
            #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton {}
                }
            #endif
        }
    }
}
