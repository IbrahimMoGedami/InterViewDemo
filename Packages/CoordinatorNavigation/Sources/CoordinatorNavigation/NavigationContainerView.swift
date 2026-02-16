//
//  NavigationContainerView.swift
//  CoordinatorNavigation
//
//  Generic container: NavigationStack + sheet + fullScreenCover + bottom sheet overlay + alert.
//  Inject your Route (Hashable), coordinator, and a view builder for Route.
//

import SwiftUI

public struct NavigationContainerView<Route: Hashable, RootContent: View, RouteContent: View>: View {
    @ObservedObject public var coordinator: NavigationCoordinator<Route>
    @ViewBuilder public let rootContent: () -> RootContent
    @ViewBuilder public let routeContent: (Route) -> RouteContent

    public init(
        coordinator: NavigationCoordinator<Route>,
        @ViewBuilder rootContent: @escaping () -> RootContent,
        @ViewBuilder routeContent: @escaping (Route) -> RouteContent
    ) {
        self.coordinator = coordinator
        self.rootContent = rootContent
        self.routeContent = routeContent
    }

    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            rootContent()
                .navigationDestination(for: Route.self) { route in
                    routeContent(route)
                }
        }
        .sheet(isPresented: Binding(
            get: { coordinator.presentedSheet != nil },
            set: { if !$0 { coordinator.dismissSheet() } }
        )) {
            if let route = coordinator.presentedSheet {
                routeContent(route)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { coordinator.presentedFullScreen != nil },
            set: { if !$0 { coordinator.dismissFullScreen() } }
        )) {
            if let route = coordinator.presentedFullScreen {
                routeContent(route)
            }
        }
        .bottomSheetOverlay(
            isPresented: coordinator.presentedBottomSheet != nil,
            onDismiss: { coordinator.dismissBottomSheet() }
        ) {
            if let route = coordinator.presentedBottomSheet {
                routeContent(route)
            }
        }
        .coordinatorAlert(config: $coordinator.alertConfig, onDismiss: { coordinator.dismissAlert() })
    }
}
