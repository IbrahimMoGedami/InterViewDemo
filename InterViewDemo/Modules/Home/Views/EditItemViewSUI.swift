//
//  EditItemViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct EditItemViewSUI: View {
    @ObservedObject var viewModel: EditItemViewModel

    var body: some View {
        Text("Edit item: \(viewModel.id)")
    }
}
