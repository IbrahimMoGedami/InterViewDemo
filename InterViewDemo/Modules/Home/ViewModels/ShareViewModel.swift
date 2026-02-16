//
//  ShareViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class ShareViewModel: ObservableObject {
    let url: String
    private let actions: HomeNavigationActions

    init(url: String, actions: HomeNavigationActions) {
        self.url = url
        self.actions = actions
    }

    func close() { actions.close() }
}
