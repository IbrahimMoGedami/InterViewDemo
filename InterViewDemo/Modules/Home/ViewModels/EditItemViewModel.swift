//
//  EditItemViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class EditItemViewModel: ObservableObject {
    let id: String
    private let actions: HomeNavigationActions

    init(id: String, actions: HomeNavigationActions) {
        self.id = id
        self.actions = actions
    }

    func pop() { actions.pop() }
}
