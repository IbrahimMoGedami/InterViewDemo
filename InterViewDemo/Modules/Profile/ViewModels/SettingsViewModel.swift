//
//  SettingsViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    private let actions: ProfileNavigationActions

    init(actions: ProfileNavigationActions) {
        self.actions = actions
    }

    func pop() { actions.pop() }
}
