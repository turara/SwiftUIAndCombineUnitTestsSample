//
//  SearchRepositoriesViewTests.swift
//  SwiftUIAndCombineUnitTestsSampleTests
//
//  Created by Turara on 2020/08/17.
//  Copyright © 2020 Turara. All rights reserved.
//

import Combine
import SwiftUI
@testable import SwiftUIAndCombineUnitTestsSample
import ViewInspector
import XCTest

extension SearchRepositoriesView: Inspectable {}

class SearchRepositoriesViewTests: XCTestCase {
    
    private var stubViewModel: SearchRepositoriesViewModelStub!
    private var view: SearchRepositoriesView<SearchRepositoriesViewModelStub>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        stubViewModel = SearchRepositoriesViewModelStub()
        view = SearchRepositoriesView(viewModel: stubViewModel)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_forEachIsEmpty_whenRepositoryListIsEmpty() throws {
        // ChildViewのindexを渡す
        let forEach = try view!.inspect().zStack().vStack(0).list(1).forEach(0)
        XCTAssertTrue(forEach.isEmpty)
    }
    
    func test_forEachCountIsEqualToRepositoryListCount_whenRepositoryListHasElements() throws {
        stubViewModel.repositoryList.append(contentsOf: stubViewModel.makeRepositories(count: 5))
        
        let forEach = try view!.inspect().zStack().vStack(0).list(1).forEach(0)
        XCTAssertEqual(forEach.count, stubViewModel.repositoryList.count)
    }
    
    func test_IndicatorShown_whenSearchingForNewQuery() throws {
        // Searching for new query
        stubViewModel.state = .loading
        stubViewModel.repositoryList = []
        
        XCTAssertNoThrow(
            try view!.inspect()
                .zStack()
                .view(ActivityIndicatorWithRectangle.self, 1)
                .actualView()
        )
    }
    
    func test_noResultsTextExist_whenNoResultsFound() throws {
        // No results found
        stubViewModel.state = .ready
        stubViewModel.repositoryList = []
        
        let text = try view!.inspect().zStack().vStack(0).list(1).text(1)
        // TODO: Update ViewInspector to get contents of modifierContext
        // XCTAssertEqual(try text.content.modifiers.count, 1)
        XCTAssertEqual(try text.string(), "No results found for ")
    }
    
    func test_searchMoreButtonNotExists_whenMoreSearchResultsNotExist() throws {
        stubViewModel.state = .ready
        stubViewModel.repositoryList.append(contentsOf: stubViewModel.makeRepositories(count: 5))
        stubViewModel.moreSearchResultsExist = false
        
        XCTAssertThrowsError(
            try view!.inspect().zStack().vStack(0).list(1).button(1)
        )
    }
    
    func test_searchMoreButtonExists_whenMoreSearchResultsExist() throws {
        stubViewModel.state = .ready
        stubViewModel.repositoryList.append(contentsOf: stubViewModel.makeRepositories(count: 5))
        stubViewModel.moreSearchResultsExist = true
        
        let button = try view!.inspect().zStack().vStack(0).list(1).button(1)
        XCTAssertEqual(try button.text().string(), "Search More ")
    }
    
    func test_searchMoreButtonSendDidPushSearchMoreEvent_whenPushed() throws {
        stubViewModel.state = .ready
        stubViewModel.repositoryList.append(contentsOf: stubViewModel.makeRepositories(count: 5))
        stubViewModel.moreSearchResultsExist = true
        
        let button = try view!.inspect().zStack().vStack(0).list(1).button(1)
        try button.tap()
        switch stubViewModel.receivedEvents.first! {
        case .didPushSearchMore:
            break
        default:
            XCTFail("Received event is not didPushSearchMore")
        }
    }
    
    func test_searchMoreButtonHasActivityIndicator_whenViewModelStateIsLoading() throws {
        stubViewModel.state = .loading
        stubViewModel.repositoryList.append(contentsOf: stubViewModel.makeRepositories(count: 5))
        stubViewModel.moreSearchResultsExist = true
        
        let button = try view!.inspect().zStack().vStack(0).list(1).button(1)
        XCTAssertNoThrow(try button.view(ActivityIndicator.self).actualView())
        XCTAssertThrowsError(try button.text())
        
        // disabled condition is not inspectable yet.
        // try button.tap()
        // XCTAssertTrue(viewModel.receivedEvents.isEmpty)
    }
    
    // Alert is not inspectable yet.
    // func test_alertShown_whenShouldShowErrorAlertTrue() {
    //    viewModel.state = .error
    //    viewModel.shouldShowErrorAlert = true
    // }
}

private class SearchRepositoriesViewModelStub: SearchRepositoriesViewModelProtocol {
    @Published var lastQuery: String?
    @Published var state: SearchRepositoriesViewModelState = .initial
    @Published var shouldShowErrorAlert: Bool = false
    @Published var repositoryList: [GitHubRepo] = []
    @Published var moreSearchResultsExist: Bool = false
    
    var receivedEvents: [SearchRepositoriesViewModelEvent] = []
    
    func send(event: SearchRepositoriesViewModelEvent) {
        receivedEvents.append(event)
    }
    
    private var currentRepositoryID: Int = 1
    
    private func makeRepository() -> GitHubRepo {
        let id = currentRepositoryID
        currentRepositoryID += 1
        return GitHubRepo(
            id: id,
            description: "Repository description \(id)",
            fullName: "Repository \(id)",
            language: "Swift",
            stargazersCount: 100,
            owner: .init(id: id, avatarURL: URL(string: "https://example.com")!),
            url: URL(string: "https://example.com")!
        )
    }
    
    func makeRepositories(count: Int) -> [GitHubRepo] {
        (0..<count).map { _ in makeRepository() }
    }
}
