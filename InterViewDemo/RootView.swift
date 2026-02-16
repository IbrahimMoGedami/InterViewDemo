//
//  RootView.swift
//  InterViewDemo
//
//  Tab bar UI only. Uses ViewModel for tab content; no coordinators here.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()

    var body: some View {
        TabView {
            viewModel.homeView
                .tabItem { Label("Home", systemImage: "house") }
            viewModel.profileView
                .tabItem { Label("Profile", systemImage: "person") }
            viewModel.authView
                .tabItem { Label("Auth", systemImage: "lock") }
        }
    }
}
