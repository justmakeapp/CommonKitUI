//
//  CheckmarkView.swift
//  AppFoundation
//
//  Created by Long Vu on 8/10/24.
//

import SwiftUI

public struct CheckmarkView: View {
    @State private var percentage: Double = 0
    @State private var didShowCheckmark = false

    public init() {}

    public var body: some View {
        Circle()
            .trim(from: 0, to: percentage)
            .stroke(color, lineWidth: 3)
            .animation(.easeInOut.speed(0.4), value: percentage)
            .overlay(content: {
                if percentage == 1 {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(color)
                        .transition(.scale.animation(.bouncy.delay(1)))
                }
            })
            .background(Circle().fill(didShowCheckmark ? color.opacity(0.2) : Color.clear))
            .onAppear {
                percentage = 1

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        didShowCheckmark = true
                    }
                }
            }
    }

    private var color: Color {
        Color.green
    }
}

#Preview {
    CheckmarkView()
        .frame(width: 80, height: 80)
}
