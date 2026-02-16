//
//  RouterView.swift
//  CoordinatorNavigation
//

import SwiftUI

/// Builds the navigation UI from coordinator state: `NavigationStack(path: path, root:)` plus
/// sheet, fullScreenCover, bottomSheet overlay, and alert.
struct RouterView<C: CoordinatorType>: View {

    @ObservedObject private var coordinator: C
    private let root: C.Route

    init(coordinator: C, root: C.Route) {
        self.coordinator = coordinator
        self.root = root
    }

    var body: some View {
        NavigationStack(path: bindingPath) {
            coordinator.viewForRoute(root)
                .navigationDestination(for: C.Route.self) { route in
                    coordinator.viewForRoute(route)
                        .toolbar(.hidden, for: .tabBar)
                }
        }
        .sheet(isPresented: Binding(
            get: { coordinator.presentedSheet != nil },
            set: { if !$0 { coordinator.presentedSheet = nil } }
        )) {
            if let route = coordinator.presentedSheet {
                coordinator.viewForRoute(route)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { coordinator.presentedFullScreen != nil },
            set: { if !$0 { coordinator.presentedFullScreen = nil } }
        )) {
            if let route = coordinator.presentedFullScreen {
                coordinator.viewForRoute(route)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .bottomSheetOverlay(
            isPresented: coordinator.presentedBottomSheet != nil,
            onDismiss: { coordinator.presentedBottomSheet = nil }
        ) {
            if let route = coordinator.presentedBottomSheet {
                coordinator.viewForRoute(route)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .coordinatorAlert(config: bindingAlert, onDismiss: { coordinator.dismissAlert() })
        .environmentObject(coordinator)
    }

    private var bindingPath: Binding<NavigationPath> {
        Binding(
            get: { coordinator.path },
            set: { coordinator.path = $0 }
        )
    }

    private var bindingAlert: Binding<AlertConfig?> {
        Binding(
            get: { coordinator.alertConfig },
            set: { coordinator.alertConfig = $0 }
        )
    }
}
