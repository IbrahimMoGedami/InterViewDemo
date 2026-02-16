//
//  CreatePostViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class CreatePostViewModel: ObservableObject {
    private let actions: AuthNavigationActions

    init(actions: AuthNavigationActions) {
        self.actions = actions
    }

    func close() { actions.close() }
}
