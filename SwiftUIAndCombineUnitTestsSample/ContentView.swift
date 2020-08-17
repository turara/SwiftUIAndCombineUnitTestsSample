//
//  ContentView.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Moya
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            makeSearchRepositoriesView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func makeSearchRepositoriesView() -> some View {
        let apiClient = MoyaProvider<GitHub>()
        let model = GitHubReposModel(apiClient: apiClient)
        let viewModel = SearchRepositoriesViewModel(model: model)
        return SearchRepositoriesView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
