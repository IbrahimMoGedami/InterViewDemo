//
//  RouteType.swift
//  CoordinatorNavigation
//

import SwiftUI

/// A route that is both a destination and a view. Your route enum conforms to `RouteType` and provides:
/// - `presentationStyle`: how to present (push, sheet, fullScreenCover, bottomSheet, etc.)
/// - `body`: the SwiftUI view for that route (from View).
///
/// **Example:** `enum AppRoute: RouteType { case home; case detail(id: String); var presentationStyle: ...; var body: some View { ... } }`
public protocol RouteType: Hashable {
    /// How this route is presented (push, sheet, fullScreenCover, detents, bottomSheet, etc.).
    var presentationStyle: TransitionPresentationStyle { get }
}
