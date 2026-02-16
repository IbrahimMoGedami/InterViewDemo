//
//  ProfileCoordinator.swift
//  InterViewDemo
//
//  Drives Profile navigation and builds views via Route. Inject `navigation` in tests.
//

import SwiftUI
import CoordinatorNavigation
import Combine

struct ProfileNavigationActions {
    var showSettings: () -> Void
    var showEditProfile: () -> Void
    var pop: () -> Void
}


protocol ProfileCoordinatorProtocol: ObservableObject {
    func showSettings()
    func showEditProfile()
    func pop()
}

@MainActor
final class ProfileCoordinator: ProfileCoordinatorProtocol {

    private let navigation: Coordinator<ProfileRoute>

    init() {
        self.navigation = Coordinator<ProfileRoute>()
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    init(navigation: Coordinator<ProfileRoute>) {
        self.navigation = navigation
        self.navigation.routeViewBuilder = { [weak self] route in
            guard let self else { return AnyView(EmptyView()) }
            return AnyView(self.view(for: route))
        }
    }

    func showSettings() {
        navigation.navigate(toRoute: .settings)
    }
    
    func showEditProfile() {
        navigation.navigate(toRoute: .editProfile)
    }
    
    func pop() {
        navigation.pop()
    }

    @ViewBuilder
    func getView() -> some View {
        navigation.getView(root: .main)
    }

    // MARK: - Private

    private func makeActions() -> ProfileNavigationActions {
        ProfileNavigationActions(
            showSettings: { [weak self] in self?.showSettings() },
            showEditProfile: { [weak self] in self?.showEditProfile() },
            pop: { [weak self] in self?.pop() }
        )
    }

    @ViewBuilder
    func view(for route: ProfileRoute) -> some View {
        route.view(actions: makeActions())
    }
}
