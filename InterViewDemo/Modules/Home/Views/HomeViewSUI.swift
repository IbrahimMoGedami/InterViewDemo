//
//  HomeViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct HomeViewSUI: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Home")
                .font(.title)
            Button("Push Detail") { viewModel.openDetail(id: "1") }
            Button("Sheet Filters") { viewModel.openFilters() }
            Button("Bottom Sheet Product") { viewModel.openProductDetail(id: "1") }
            Button("Alert Error") { viewModel.showError() }
        }
    }
}
