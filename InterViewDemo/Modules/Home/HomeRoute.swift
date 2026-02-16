//
//  HomeRoute.swift
//  InterViewDemo
//
//  Home destinations + presentation style. `view(actions:)` builds the screen for this route.
//

import SwiftUI
import CoordinatorNavigation

enum HomeRoute: RouteType {
    case main
    case detail(id: String)
    case editItem(id: String)
    case list(category: String)
    case filters
    case productDetail(id: String)
    case share(url: String)

    var presentationStyle: TransitionPresentationStyle {
        switch self {
        case .main, .detail, .editItem, .list: return .push
        case .filters, .share: return .sheet
        case .productDetail: return .bottomSheet
        }
    }

    @ViewBuilder
    func view(actions: HomeNavigationActions) -> some View {
        switch self {
        case .main:
            HomeViewSUI(viewModel: HomeViewModel(actions: actions))
                .navigationTitle("Home")
        case .detail(let id):
            DetailViewSUI(viewModel: DetailViewModel(id: id, actions: actions))
                .navigationTitle("Detail")
        case .editItem(let id):
            EditItemViewSUI(viewModel: EditItemViewModel(id: id, actions: actions))
                .navigationTitle("Edit")
        case .list(let category):
            ListViewSUI(viewModel: ListViewModel(category: category, actions: actions))
                .navigationTitle("List")
        case .filters:
            FiltersViewSUI(viewModel: FiltersViewModel(actions: actions))
                .navigationTitle("Filters")
        case .productDetail(let id):
            ProductDetailViewSUI(viewModel: ProductDetailViewModel(id: id, actions: actions))
                .padding().frame(maxWidth: .infinity).frame(height: 280)
        case .share(let url):
            ShareViewSUI(viewModel: ShareViewModel(url: url, actions: actions))
                .navigationTitle("Share")
        }
    }
}
