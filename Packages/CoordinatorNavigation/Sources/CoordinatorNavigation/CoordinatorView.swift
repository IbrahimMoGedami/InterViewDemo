//
//  CoordinatorView.swift
//  CoordinatorNavigation
//

import SwiftUI

/// SwiftUI view that wraps a coordinator and shows its navigation UI via `RouterView`.
/// Use via `coordinator.getView(root: .main)` in your app entry.
public struct CoordinatorView<DataSource: CoordinatorType>: View {

    private let dataSource: DataSource
    private let root: DataSource.Route

    public init(dataSource: DataSource, root: DataSource.Route) {
        self.dataSource = dataSource
        self.root = root
    }

    public var body: some View {
        RouterView(coordinator: dataSource, root: root)
    }
}
