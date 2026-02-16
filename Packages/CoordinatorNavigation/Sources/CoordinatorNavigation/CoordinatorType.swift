//
//  CoordinatorType.swift
//  CoordinatorNavigation
//

import Combine
import Foundation
import SwiftUI

/// Protocol for coordinators. Subclass `Coordinator<Route>` to get full state and navigation methods.
/// Exposes navigation state so `RouterView` can build the UI (stack, sheet, fullScreen, bottomSheet, alert).
@MainActor
public protocol CoordinatorType: ObservableObject {
    associatedtype Route: RouteType
    /// Navigation path (push stack). Use NavigationPath for type-safe programmatic navigation.
    var path: NavigationPath { get set }
    /// Currently presented sheet route, or nil if none.
    var presentedSheet: Route? { get set }
    /// Currently presented full-screen route, or nil if none.
    var presentedFullScreen: Route? { get set }
    /// Currently presented bottom-sheet route, or nil if none.
    var presentedBottomSheet: Route? { get set }
    /// Current alert to show, or nil.
    var alertConfig: AlertConfig? { get set }
    /// Clears the current alert.
    func dismissAlert()
    /// Optional: when set, used to build the view for a route. Stays in coordinator only; no env/host.
    var routeViewBuilder: ((Route) -> AnyView)? { get }
    func viewForRoute(_ route: Route) -> AnyView
}

public extension CoordinatorType {
    var routeViewBuilder: ((Route) -> AnyView)? { nil }
    func viewForRoute(_ route: Route) -> AnyView {
        routeViewBuilder?(route) ?? AnyView(EmptyView())
    }
}
