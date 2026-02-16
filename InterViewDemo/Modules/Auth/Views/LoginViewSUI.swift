//
//  LoginViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct LoginViewSUI: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("Login")
            Button("Dismiss") { viewModel.close() }
            Button("Create Post") { viewModel.openCreatePost() }
        }
    }
}
