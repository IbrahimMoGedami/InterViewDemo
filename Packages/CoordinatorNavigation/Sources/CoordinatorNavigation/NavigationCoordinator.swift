//
//  NavigationCoordinator.swift
//  CoordinatorNavigation
//
//  Generic coordinator: stack + sheet + fullScreen + bottom sheet + alert.
//  Use in any project by defining your own Route (Hashable) and mapping Route -> PresentationStyle.
//

import SwiftUI
import Combine

@MainActor
open class NavigationCoordinator<Route: Hashable>: ObservableObject {

    @Published public var navigationPath = NavigationPath()
    @Published public var presentedSheet: Route?
    @Published public var presentedFullScreen: Route?
    @Published public var presentedBottomSheet: Route?
    @Published public var alertConfig: AlertConfig?

    private let styleMapping: (Route) -> PresentationStyle

    public init(styleMapping: @escaping (Route) -> PresentationStyle) {
        self.styleMapping = styleMapping
    }

    // MARK: - Stack
    public func push(_ route: Route) {
        navigationPath.append(route)
    }

    public func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    public func popToRoot() {
        navigationPath = NavigationPath()
    }

    public func pop(count: Int) {
        guard count > 0, navigationPath.count >= count else { return }
        for _ in 0..<count { navigationPath.removeLast() }
    }

    // MARK: - Dismiss
    /// Dismisses the topmost presentation. If none, pops to root.
    public func dismiss() {
        if presentedSheet != nil { dismissSheet() }
        else if presentedFullScreen != nil { dismissFullScreen() }
        else if presentedBottomSheet != nil { dismissBottomSheet() }
        else { popToRoot() }
    }

    public func dismissSheet() { presentedSheet = nil }
    public func dismissFullScreen() { presentedFullScreen = nil }
    public func dismissBottomSheet() { presentedBottomSheet = nil }
    public func dismissAlert() { alertConfig = nil }

    // MARK: - Present by style
    public func presentSheet(_ route: Route) { presentedSheet = route }
    public func presentFullScreen(_ route: Route) { presentedFullScreen = route }
    public func presentBottomSheet(_ route: Route) { presentedBottomSheet = route }
    public func showAlert(_ config: AlertConfig) { alertConfig = config }

    /// Present a route using its mapped PresentationStyle.
    public func present(_ route: Route) {
        switch styleMapping(route) {
        case .push: push(route)
        case .sheet: presentSheet(route)
        case .fullScreenCover: presentFullScreen(route)
        case .bottomSheet: presentBottomSheet(route)
        case .alert(let config): showAlert(config)
        }
    }
}
