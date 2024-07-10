//
//  CustomEmptyView.swift
//
//
//  Created by Long Vu on 10/12/2023.
//

import SwiftUI

public struct CustomEmptyView: View {
    private let title: String
    private let systemImage: String

    public init(title: String, systemImage: String = "tray") {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .imageScale(.large)

            Text(title)
                .font(.title3.weight(.semibold))
        }
        .foregroundColor(.secondary)
        .padding()
    }
}
