//
//  EditorView.swift
//
//  Created by Long Vu on 18/12/24.
//

import SwiftUI

public struct EditorView: View {
    let title: String
    @Binding var text: String

    @FocusState.Binding private var isFocused: Bool

    public init(title: String, text: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self.title = title
        self._text = text
        self._isFocused = isFocused
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        ZStack {
            TextEditor(text: $text)
            #if os(macOS)
                .font(.title3)
            #endif
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button("", systemImage: "keyboard.chevron.compact.down") {
                            withAnimation {
                                isFocused = false
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
        }
    }
}

#if DEBUG
    private struct PreviewContentView: View {
        @FocusState private var isFocused: Bool

        var body: some View {
            EditorView(title: "Placeholder", text: .constant(""), isFocused: $isFocused)
        }
    }

    #Preview {
        PreviewContentView()
    }

#endif
