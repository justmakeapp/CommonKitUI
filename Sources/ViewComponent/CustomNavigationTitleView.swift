//
//  CustomNavigationTitleView.swift
//  ConversationKit
//
//  Created by Long Vu on 9/10/24.
//

import SwiftUI

public struct CustomNavigationTitleView: View {
    let title: String

    public init(_ title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
