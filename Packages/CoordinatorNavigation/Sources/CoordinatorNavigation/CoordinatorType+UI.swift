//
//  CoordinatorType+UI.swift
//  CoordinatorNavigation
//

import SwiftUI

public extension CoordinatorType {

    /// Returns the coordinator as the root SwiftUI view. Use in your app entry: `coordinator.getView(root: .main)`.
    @ViewBuilder
    func getView(root: Route) -> some View {
        CoordinatorView(dataSource: self, root: root)
    }
}
