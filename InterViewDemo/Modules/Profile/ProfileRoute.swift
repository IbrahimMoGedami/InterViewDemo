//
//  ProfileRoute.swift
//  InterViewDemo
//
//  Profile destinations + presentation style. `view(actions:)` builds the screen for this route.
//

import SwiftUI
import CoordinatorNavigation

enum ProfileRoute: RouteType {
    case main
    case settings
    case editProfile

    var presentationStyle: TransitionPresentationStyle {
        .push
    }

    @ViewBuilder
    func view(actions: ProfileNavigationActions) -> some View {
        switch self {
        case .main:
            ProfileViewSUI(viewModel: ProfileViewModel(actions: actions))
                .navigationTitle("Profile")
        case .settings:
            SettingsViewSUI(viewModel: SettingsViewModel(actions: actions))
                .navigationTitle("Settings")
        case .editProfile:
            EditProfileViewSUI(viewModel: EditProfileViewModel(actions: actions))
                .navigationTitle("Edit Profile")
        }
    }
}
