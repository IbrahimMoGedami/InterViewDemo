//
//  CreatePostViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct CreatePostViewSUI: View {
    @ObservedObject var viewModel: CreatePostViewModel

    var body: some View {
        VStack {
            Text("Create Post")
            Button("Dismiss") { viewModel.close() }
        }
    }
}
