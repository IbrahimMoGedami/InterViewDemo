//
//  ProfileViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    private let actions: ProfileNavigationActions

    init(actions: ProfileNavigationActions) {
        self.actions = actions
    }

    func openSettings() { actions.showSettings() }
    func openEditProfile() { actions.showEditProfile() }
}
