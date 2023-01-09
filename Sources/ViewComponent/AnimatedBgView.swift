//
//  AnimatedBgView.swift
//
//
//  Created by Long Vu on 03/10/2022.
//

import Combine
import SwiftUI

public struct AnimatedBgView<BgView: View>: ViewModifier {
    @State private var offsetX: CGFloat = 0
    @State private var sign: CGFloat
    private let step: CGFloat
    @State private var screenSize: CGSize = .zero
    @State private var imageSize: CGSize = .zero
    @State private var didAppear = false

    private let timer: AnyPublisher<Date, Never>
    private let bgViewBuilder: () -> BgView

    public init(
        timeInterval: TimeInterval = 0.1,
        sign: CGFloat = -1,
        step: CGFloat = 3,
        @ViewBuilder _ bgViewBuilder: @escaping () -> BgView
    ) {
        self.timer = Timer.publish(every: timeInterval, on: .main, in: .common).autoconnect()
            .eraseToAnyPublisher()
        self.step = step
        self._sign = .init(initialValue: sign)
        self.bgViewBuilder = bgViewBuilder
    }

    public func body(content: Content) -> some View {
        content
            .overlay(overlayView)
            .readSize(onChange: { size in
                if size != screenSize {
                    screenSize = size
                }
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    didAppear = true
                }
            }
            .onReceive(timer) { _ in
                guard didAppear else {
                    return
                }
                let max = max((imageSize.width - screenSize.width) / 2, 0)
                guard max >= 50 else {
                    return
                }
                withAnimation {
                    if offsetX < -max, sign == -1 {
                        sign = 1
                    } else if offsetX > max, sign == 1 {
                        sign = -1
                    }
                    offsetX += step * sign
                }
            }
    }

    private var overlayView: some View {
        bgViewBuilder()
            .offset(x: offsetX)
            .readSize { size in
                if size != imageSize {
                    imageSize = size
                }
            }
    }
}
