//
//  DetailViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct DetailViewSUI: View {
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        VStack {
            Text("Detail: \(viewModel.id)")
            Button("Back") { viewModel.pop() }
        }
    }
}
