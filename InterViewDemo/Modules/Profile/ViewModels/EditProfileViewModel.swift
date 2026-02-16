//
//  EditProfileViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class EditProfileViewModel: ObservableObject {
    private let actions: ProfileNavigationActions

    init(actions: ProfileNavigationActions) {
        self.actions = actions
    }

    func pop() { actions.pop() }
}
