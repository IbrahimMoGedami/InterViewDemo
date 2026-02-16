//
//  HomeViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    private let actions: HomeNavigationActions

    init(actions: HomeNavigationActions) {
        self.actions = actions
    }

    func openDetail(id: String) { actions.showDetail(id) }
    func openFilters() { actions.showFilters() }
    func openProductDetail(id: String) { actions.showProductDetail(id) }
    func showError() { actions.showError() }
    func openShare(url: String) { actions.showShare(url) }
    func pop() { actions.pop() }
    func close() { actions.close() }
}
