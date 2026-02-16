//
//  PresentationStyle.swift
//  CoordinatorNavigation
//
//  How a route is presented. Reusable across projects.
//

import Foundation

public enum PresentationStyle {
    case push
    case sheet
    case fullScreenCover
    case bottomSheet
    case alert(AlertConfig)
}
