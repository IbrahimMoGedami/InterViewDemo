//
//  ProductDetailViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct ProductDetailViewSUI: View {
    @ObservedObject var viewModel: ProductDetailViewModel

    var body: some View {
        VStack {
            Text("Product: \(viewModel.id)")
            Button("Close") { viewModel.close() }
        }
    }
}
