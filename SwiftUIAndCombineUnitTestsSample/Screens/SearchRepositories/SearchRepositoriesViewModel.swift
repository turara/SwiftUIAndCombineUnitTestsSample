//
//  SearchRepositoriesViewModel.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Combine
import Foundation

enum SearchRepositoriesViewModelState {
    case initial
    case loading
    case ready
    case error
}

enum SearchRepositoriesViewModelEvent {
    case didSearchButtonClicked(query: String)
    case didPushSearchMore
}

protocol SearchRepositoriesViewModelProtocol: ObservableObject {
    var lastQuery: String? { get }
    var state: SearchRepositoriesViewModelState { get }
    // "set" is needed because this prop is used as Binding<Bool>
    var shouldShowErrorAlert: Bool { get set }
    var repositoryList: [GitHubRepo] { get }
    var moreSearchResultsExist: Bool { get }
    func send(event: SearchRepositoriesViewModelEvent)
}

class SearchRepositoriesViewModel {
    private let reposModel: GitHubReposModelProtocol
    
    @Published private(set) var lastQuery: String?
    @Published private(set) var state: SearchRepositoriesViewModelState = .initial {
        didSet {
            shouldShowErrorAlert =  oldValue != state && state == .error
        }
    }
    @Published var shouldShowErrorAlert: Bool = false
    @Published private(set) var repositoryList: [GitHubRepo] = []
    @Published private(set) var moreSearchResultsExist: Bool = false
    
    private var currentPage: Int = 1
    
    init(model: GitHubReposModelProtocol) {
        reposModel = model
    }
}

extension SearchRepositoriesViewModel: SearchRepositoriesViewModelProtocol {
    func send(event: SearchRepositoriesViewModelEvent) {
        switch event {
        case let .didSearchButtonClicked(query: query):
            lastQuery = query
            currentPage = 1
            repositoryList = []
            moreSearchResultsExist = false
            fetchRepositories(query: query)
        case .didPushSearchMore:
            currentPage += 1
            fetchRepositories()
        }
    }
}

private extension SearchRepositoriesViewModel {
    func fetchRepositories(query optioanlQuery: String? = nil) {
        guard let query = optioanlQuery ?? lastQuery else {
            return
        }
        
        state = .loading
        
        reposModel.fetchRepos(withQuery: query, page: currentPage) { [weak self] repoItems in
            guard let self = self else {
                return
            }
            
            if let repoItems = repoItems {
                self.repositoryList.append(contentsOf: repoItems.items)
                self.moreSearchResultsExist = self.repositoryList.count < repoItems.totalCount
                self.state = .ready
            } else {
                self.state = .error
                self.currentPage -= 1
            }
        }
    }
}
