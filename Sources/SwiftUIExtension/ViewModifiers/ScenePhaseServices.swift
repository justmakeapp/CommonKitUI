//
//  ScenePhaseServices.swift
//  CommonKitUI
//
//  Created by Long Vu on 13/10/24.
//

import Foundation
import SwiftUI

public protocol ApplicationService: AnyObject {
    func becomeActive()
    func resignActive()
    func enterBackground()

    func performTaskBeforeAppAppear() async
}

public extension ApplicationService {
    func becomeActive() {}
    func resignActive() {}
    func enterBackground() {}

    func performTaskBeforeAppAppear() async {}
}

public struct ScenePhaseServices: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase

    private let services: [ApplicationService]

    public init(_ services: [ApplicationService]) {
        self.services = services
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    for service in services {
                        service.becomeActive()
                    }
                case .inactive:
                    for service in services {
                        service.resignActive()
                    }
                case .background:
                    for service in services {
                        service.enterBackground()
                    }
                @unknown default:
                    return
                }
            }
    }
}
