//
//  CustomNavigationTitleView.swift
//  ConversationKit
//
//  Created by Long Vu on 9/10/24.
//

import SwiftUI
import SwiftUIExtension

public struct CustomNavigationTitleView: View {
    let title: String

    private var config = Config()

    public init(_ title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .lineLimit(config.lineLimit)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public extension CustomNavigationTitleView {
    struct Config {
        var lineLimit: Int? = 2
    }

    func lineLimit(_ limit: Int?) -> Self {
        transform { $0.config.lineLimit = limit }
    }
}
