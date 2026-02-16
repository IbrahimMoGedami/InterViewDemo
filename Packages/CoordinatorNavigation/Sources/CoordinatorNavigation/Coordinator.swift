//
//  Coordinator.swift
//  CoordinatorNavigation
//

import SwiftUI
import Combine


/// Base coordinator: owns all navigation state and provides navigate/close/pop/alert methods.
///
/// **State:** `path` (NavigationPath stack), `presentedSheet`, `presentedFullScreen`, `presentedBottomSheet`, `alertConfig`.
///
/// **Usage:** `Coordinator<MyRoute>()` then show `coordinator.getView(root: .main)` as the root view.
@MainActor
open class Coordinator<Route: RouteType>: ObservableObject, CoordinatorType {

    @Published public var path = NavigationPath()
    @Published public var presentedSheet: Route?
    @Published public var presentedFullScreen: Route?
    @Published public var presentedBottomSheet: Route?
    @Published public var alertConfig: AlertConfig?

    public var routeViewBuilder: ((Route) -> AnyView)? = nil

    public init() {}

    /// Navigate to a route: push or present by route.presentationStyle.
    public func navigate(toRoute route: Route, presentationStyle: TransitionPresentationStyle? = nil, animated: Bool = true) {
        let style = presentationStyle ?? route.presentationStyle

        switch style {
        case .push:
            path.append(route)
        case .sheet, .detents:
            presentedSheet = route
        case .fullScreenCover:
            presentedFullScreen = route
        case .bottomSheet:
            presentedBottomSheet = route
        case .custom:
            presentedFullScreen = route
        }
    }

    /// Present a route (modal). If style is push, delegates to navigate.
    public func present(_ route: Route, presentationStyle: TransitionPresentationStyle? = nil, animated: Bool = true) {
        let style = presentationStyle ?? route.presentationStyle
        if style == .push {
            navigate(toRoute: route, presentationStyle: .push, animated: animated)
            return
        }
        navigate(toRoute: route, presentationStyle: style, animated: animated)
    }

    public func pop() {
        guard path.count > 0 else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path = NavigationPath()
    }

    /// Dismiss topmost modal; if none, pop stack.
    public func dismiss() {
        if presentedSheet != nil { presentedSheet = nil }
        else if presentedFullScreen != nil { presentedFullScreen = nil }
        else if presentedBottomSheet != nil { presentedBottomSheet = nil }
        else if path.count > 0 { path.removeLast() }
    }

    /// Close: dismiss sheet/fullScreen/bottomSheet first, else pop.
    public func close() {
        if presentedSheet != nil || presentedFullScreen != nil || presentedBottomSheet != nil {
            presentedSheet = nil
            presentedFullScreen = nil
            presentedBottomSheet = nil
        } else {
            pop()
        }
    }

    public func dismissAlert() { alertConfig = nil }

    /// Clean all stack and modals.
    public func finishFlow(animated: Bool = true) {
        path = NavigationPath()
        presentedSheet = nil
        presentedFullScreen = nil
        presentedBottomSheet = nil
        alertConfig = nil
    }

    public func showAlert(_ config: AlertConfig) {
        alertConfig = config
    }
}
