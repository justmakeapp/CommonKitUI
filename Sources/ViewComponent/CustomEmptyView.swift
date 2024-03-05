//
//  CustomEmptyView.swift
//
//
//  Created by Long Vu on 10/12/2023.
//

import SwiftUI

public struct CustomEmptyView: View {
    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        VStack {
            Image(systemName: "tray")
                .font(.largeTitle)
                .imageScale(.large)

            Text(title)
                .font(.title3.weight(.semibold))
        }
        .foregroundColor(.secondary)
        .padding()
    }
}
