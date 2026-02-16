//
//  HomeCoordinator.swift
//  InterViewDemo
//
//  Drives Home navigation and builds views via Route. Inject `navigation` in tests.
//

import SwiftUI
import CoordinatorNavigation
import Combine

struct HomeNavigationActions {
    var showDetail: (String) -> Void
    var showFilters: () -> Void
    var showProductDetail: (String) -> Void
    var showError: () -> Void
    var showShare: (String) -> Void
    var pop: () -> Void
    var close: () -> Void
}

protocol HomeCoordinatorProtocol: AnyObject {
    func showDetail(id: String)
    func showFilters()
    func showProductDetail(id: String)
    func showError()
    func showShare(url: String)
    func pop()
    func close()
}

@MainActor
final class HomeCoordinator: ObservableObject, HomeCoordinatorProtocol {

    private let navigation: Coordinator<HomeRoute>

    init() {
        self.navigation = Coordinator<HomeRoute>()
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    init(navigation: Coordinator<HomeRoute>) {
        self.navigation = navigation
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    func showDetail(id: String) { navigation.navigate(toRoute: .detail(id: id)) }
    func showFilters() { navigation.navigate(toRoute: .filters) }
    func showProductDetail(id: String) { navigation.navigate(toRoute: .productDetail(id: id)) }
    func showError() { navigation.showAlert(AlertConfig(title: "Error", message: "Something went wrong.", primaryTitle: "OK")) }
    func showShare(url: String) { navigation.navigate(toRoute: .share(url: url)) }
    func pop() { navigation.pop() }
    func close() { navigation.close() }

    @ViewBuilder
    func getView() -> some View {
        navigation.getView(root: .main)
    }

    // MARK: - Private

    private func makeActions() -> HomeNavigationActions {
        HomeNavigationActions(
            showDetail: { [weak self] id in self?.showDetail(id: id) },
            showFilters: { [weak self] in self?.showFilters() },
            showProductDetail: { [weak self] id in self?.showProductDetail(id: id) },
            showError: { [weak self] in self?.showError() },
            showShare: { [weak self] url in self?.showShare(url: url) },
            pop: { [weak self] in self?.pop() },
            close: { [weak self] in self?.close() }
        )
    }

    @ViewBuilder
    func view(for route: HomeRoute) -> some View {
        route.view(actions: makeActions())
    }
}
