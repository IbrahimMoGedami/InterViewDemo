//
//  ProfileViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct ProfileViewSUI: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
            Button("Settings") { viewModel.openSettings() }
            Button("Edit Profile") { viewModel.openEditProfile() }
        }
    }
}
