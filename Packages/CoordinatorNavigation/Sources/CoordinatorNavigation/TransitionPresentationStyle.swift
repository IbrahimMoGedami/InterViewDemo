//
//  TransitionPresentationStyle.swift
//  CoordinatorNavigation
//

import SwiftUI

/// How a route is presented. Use in your route’s `presentationStyle`.
public enum TransitionPresentationStyle: Equatable {
    public static func == (lhs: TransitionPresentationStyle, rhs: TransitionPresentationStyle) -> Bool {
        return true
    }
    
    case push
    case sheet
    case fullScreenCover
    case detents(Set<PresentationDetent>)
    case bottomSheet
    case custom(transition: AnyTransition, animation: Animation?, fullScreen: Bool = false)

    public static var bottomSheetOverlay: TransitionPresentationStyle { .bottomSheet }
}
