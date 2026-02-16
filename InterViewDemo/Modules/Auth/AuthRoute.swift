//
//  AuthRoute.swift
//  InterViewDemo
//
//  Auth destinations + presentation style. `view(actions:)` builds the screen for this route.
//

import SwiftUI
import CoordinatorNavigation

enum AuthRoute: RouteType {
    case login
    case createPost

    var presentationStyle: TransitionPresentationStyle {
        .fullScreenCover
    }

    @ViewBuilder
    func view(actions: AuthNavigationActions) -> some View {
        switch self {
        case .login:
            LoginViewSUI(viewModel: LoginViewModel(actions: actions))
                .navigationTitle("Login")
        case .createPost:
            CreatePostViewSUI(viewModel: CreatePostViewModel(actions: actions))
                .navigationTitle("New Post")
        }
    }
}
