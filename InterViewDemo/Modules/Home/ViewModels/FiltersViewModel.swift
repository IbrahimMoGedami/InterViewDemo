//
//  FiltersViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class FiltersViewModel: ObservableObject {
    private let actions: HomeNavigationActions

    init(actions: HomeNavigationActions) {
        self.actions = actions
    }

    func close() { actions.close() }
}
