//
//  EditorView.swift
//
//  Created by Long Vu on 18/12/24.
//

import SwiftUI

public struct EditorView: View {
    let title: String
    @Binding var text: String

    @FocusState.Binding private var focusedField: String?

    private var config = Config()

    public init(
        title: String,
        text: Binding<String>,
        focusedField: FocusState<String?>.Binding
    ) {
        self.title = title
        self._text = text
        self._focusedField = focusedField
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        ZStack {
            #if os(macOS) || os(iOS)
                TextEditor(text: $text)
                #if os(macOS)
                    .font(.title3)
                #endif
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: Self.focusedFieldId)
                    .toolbar {
                        if focusedField == Self.focusedFieldId {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()

                                Button("", systemImage: "keyboard.chevron.compact.down") {
                                    withAnimation {
                                        focusedField = nil
                                        config.onDismissKeyboard()
                                    }
                                }
                            }
                        }
                    }

                if text.isEmpty {
                    VStack {
                        HStack {
                            Text(title)
                            #if os(macOS)
                                .font(.title3)
                            #endif
                                .foregroundStyle(.tertiary)
                            #if os(iOS)
                                .padding(.top, 8)
                            #endif
                                .padding(.leading, 5)

                            Spacer()
                        }

                        Spacer()
                    }
                }
            #endif
        }
    }
}

public extension EditorView {
    static let focusedFieldId = "ViewComponent.EditorView"

    struct Config {
        var onDismissKeyboard: () -> Void = {}
    }

    func onDismissKeyboard(_ action: @escaping () -> Void) -> Self {
        transform { $0.config.onDismissKeyboard = action }
    }
}

#if DEBUG
    private struct PreviewContentView: View {
        @FocusState private var focusedField: String?

        var body: some View {
            EditorView(
                title: "Placeholder",
                text: .constant(""),
                focusedField: $focusedField
            )
        }
    }

    #Preview {
        PreviewContentView()
    }

#endif
