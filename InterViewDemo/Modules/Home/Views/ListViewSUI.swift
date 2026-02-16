//
//  ListViewSUI.swift
//  InterViewDemo
//

import SwiftUI
import CoordinatorNavigation

struct ListViewSUI: View {
    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        Text("List: \(viewModel.category)")
    }
}
