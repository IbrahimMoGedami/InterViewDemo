//
//  LoginViewModel.swift
//  InterViewDemo
//
//  Login screen logic. Depends only on AuthNavigationActions (testable: inject mock actions).
//

import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    private let actions: AuthNavigationActions

    init(actions: AuthNavigationActions) {
        self.actions = actions
    }

    func openCreatePost() { actions.showCreatePost() }
    func close() { actions.close() }
}
