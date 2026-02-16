//
//  FiltersViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct FiltersViewSUI: View {
    @ObservedObject var viewModel: FiltersViewModel

    var body: some View {
        VStack {
            Text("Filters")
            Button("Done") { viewModel.close() }
        }
    }
}
