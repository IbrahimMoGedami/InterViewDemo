//
//  AlertConfig.swift
//  CoordinatorNavigation
//
//  Model for presenting an alert. Reusable across projects.
//

import Foundation

public struct AlertConfig {
    public let title: String
    public let message: String?
    public let primaryTitle: String
    public var primaryAction: (() -> Void)?
    public var secondaryTitle: String?
    public var secondaryAction: (() -> Void)?

    public init(
        title: String,
        message: String? = nil,
        primaryTitle: String,
        primaryAction: (() -> Void)? = nil,
        secondaryTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
    }
}
