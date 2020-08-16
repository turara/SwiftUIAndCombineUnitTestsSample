//
//  SearchRepositoriesView.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/17.
//  Copyright © 2020 Turara. All rights reserved.
//

import Combine
import SwiftUI

struct SearchRepositoriesView<ViewModel: SearchRepositoriesViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                // TODO: Show search bar
                Text("Search bar here")
                List {
                    ForEach(viewModel.repositoryList, id: \.id) { repository in
                        // TODO: Show cell
                        Text(repository.fullName)
                    }
                    
                    if self.isReady && self.isListEmpty {
                        noResultsText
                    } else if self.viewModel.moreSearchResultsExist {
                        self.searchMoreButton
                    }
                }
                
            }
            if isLoading && isListEmpty {
                // TODO: Show indicator
                Text("Now searching")
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Search Repositories", displayMode: .inline)
        .alert(isPresented: $viewModel.shouldShowErrorAlert) { errorAlert }
    }
    
    private var noResultsText: some View {
        (Text("No results found for ") +
            Text(self.lastQuery)
                .font(.headline)
                .bold()
                .italic()
            )
            .padding()
    }
    
    private var errorAlert: Alert {
        Alert(title: Text("Failed to search"), message: Text("Something went wrong..."))
    }
    
    private var searchMoreButton: some View {
        Button(action: {
            self.viewModel.send(event: .didPushSearchMore)
        }) {
            if self.isLoading {
                // TODO: Show indicator
                Text("Now searching...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                (Text("Search More ") +
                    Text(self.lastQuery)
                        .font(.headline)
                        .bold()
                        .italic()
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .buttonStyle(BorderlessButtonStyle())
        .disabled(isLoading)
    }
}

private extension SearchRepositoriesView {
    var isReady: Bool {
        viewModel.state == .ready
    }
    
    var isLoading: Bool {
        viewModel.state == .loading
    }
    
    var isListEmpty: Bool {
        viewModel.repositoryList.isEmpty
    }
    
    var lastQuery: String {
        viewModel.lastQuery ?? ""
    }
}

#if DEBUG
struct SearchRepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GitHubReposModel.makeModelWithStub()
        let viewModel = SearchRepositoriesViewModel(model: model)
        return SearchRepositoriesView(viewModel: viewModel)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
