import SwiftUI
#if canImport(UIKit.UIImpactFeedbackGenerator)
    import UIKit.UIImpactFeedbackGenerator
#endif

public struct CloseButton: View {
    let action: () -> Void

    public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: {
            #if canImport(UIKit.UIImpactFeedbackGenerator)
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            #endif

            action()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundColor(Color.secondary.opacity(0.6))
        })
        .buttonStyle(.plain)
        .keyboardShortcut(.cancelAction)
    }
}
