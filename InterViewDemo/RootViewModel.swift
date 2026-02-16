//
//  RootViewModel.swift
//  InterViewDemo
//
//  Tab bar: owns coordinators and exposes only tab content views. View has no coordinators.
//

import SwiftUI
import CoordinatorNavigation
import Combine

@MainActor
final class TabBarViewModel: ObservableObject {
    private let homeCoordinator = HomeCoordinator()
    private let profileCoordinator = ProfileCoordinator()
    private let authCoordinator = AuthCoordinator()

    var homeView: some View {
        homeCoordinator.getView()
    }

    var profileView: some View {
        profileCoordinator.getView()
    }

    var authView: some View {
        authCoordinator.getView()
    }
}
