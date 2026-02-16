//
//  AuthCoordinator.swift
//  InterViewDemo
//
//  Drives Auth navigation and builds views via Route. Inject `navigation` in tests.
//

import CoordinatorNavigation
import SwiftUI
import Combine

struct AuthNavigationActions {
    var showCreatePost: () -> Void
    var close: () -> Void
}

protocol AuthCoordinatorProtocol: AnyObject {
    func showCreatePost()
    func close()
}

@MainActor
final class AuthCoordinator: AuthCoordinatorProtocol {

    private let navigation: Coordinator<AuthRoute>

    init() {
        self.navigation = Coordinator<AuthRoute>()
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    init(navigation: Coordinator<AuthRoute>) {
        self.navigation = navigation
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    func showCreatePost() { navigation.navigate(toRoute: .createPost) }
    func close() { navigation.close() }

    @ViewBuilder
    func getView() -> some View {
        navigation.getView(root: .login)
    }

    // MARK: - Private

    private func makeActions() -> AuthNavigationActions {
        AuthNavigationActions(
            showCreatePost: { [weak self] in self?.showCreatePost() },
            close: { [weak self] in self?.close() }
        )
    }

    @ViewBuilder
    func view(for route: AuthRoute) -> some View {
        route.view(actions: makeActions())
    }
}
