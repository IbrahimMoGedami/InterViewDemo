//
//  ListViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class ListViewModel: ObservableObject {
    let category: String
    private let actions: HomeNavigationActions

    init(category: String, actions: HomeNavigationActions) {
        self.category = category
        self.actions = actions
    }

    func pop() { actions.pop() }
}
