//
//  ShareViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct ShareViewSUI: View {
    @ObservedObject var viewModel: ShareViewModel

    var body: some View {
        VStack {
            Text("Share: \(viewModel.url)")
            Button("Close") { viewModel.close() }
        }
    }
}
