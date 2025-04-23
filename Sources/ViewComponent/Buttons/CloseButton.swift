import SwiftUI

/// https://github.com/joogps/ExitButton
// struct ExitButtonView: View {
//    @Environment(\.colorScheme) var colorScheme
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
//            Image(systemName: "xmark")
//                .resizable()
//                .scaledToFit()
//                .font(Font.body.weight(.bold))
//                .scaleEffect(0.416)
//                .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
//        }
//    }
// }

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

    private var buttonLabel: some View {
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
    VStack {
        CloseButton {}
    }
}
