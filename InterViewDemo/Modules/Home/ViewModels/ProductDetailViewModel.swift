//
//  ProductDetailViewModel.swift
//  InterViewDemo
//

import Combine
import Foundation

@MainActor
final class ProductDetailViewModel: ObservableObject {
    let id: String
    private let actions: HomeNavigationActions

    init(id: String, actions: HomeNavigationActions) {
        self.id = id
        self.actions = actions
    }

    func close() { actions.close() }
}
