//
//  SearchRepositoriesViewModel.swift
//  SwiftUIAndCombineUnitTestsSampleTests
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import EntwineTest
import Moya
@testable import SwiftUIAndCombineUnitTestsSample
import XCTest


class SearchRepositoriesViewModelTests: XCTestCase {
    
    private var stubModel: GitHubReposModelStub!
    private var viewModel: SearchRepositoriesViewModel!
    
    override func setUpWithError() throws {
        stubModel = GitHubReposModelStub()
        viewModel = SearchRepositoriesViewModel(model: stubModel)
    }
    
    override func tearDownWithError() throws {}
    
}

// MARK: Tests for didSearchButtonClicked event

extension SearchRepositoriesViewModelTests {
    func test_lastQueryIsPublished_whenDidSearchButtonClicked() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Python"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(String?.self, Never.self)
        viewModel.$lastQuery.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<String?, Never> = [
            (000, .subscription),
            (000, .input(nil)),
            (100, .input("Swift")),
            (200, .input("Python")),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_stateIsPublished_forNormalResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = makeGitHubRepoItems(withItemCount: 0, totalCount: 0)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(
            SearchRepositoriesViewModelState.self,
            Never.self
        )
        viewModel.$state.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<SearchRepositoriesViewModelState, Never> = [
            (000, .subscription),
            (000, .input(.initial)),
            (100, .input(.loading)),
            (100, .input(.ready)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_stateIsPublished_forErrorResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(
            SearchRepositoriesViewModelState.self,
            Never.self
        )
        viewModel.$state.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<SearchRepositoriesViewModelState, Never> = [
            (000, .subscription),
            (000, .input(.initial)),
            (100, .input(.loading)),
            (100, .input(.error)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_shouldShowErrorAlertIsNotPublished_forNormalResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = makeGitHubRepoItems(withItemCount: 0, totalCount: 0)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$shouldShowErrorAlert.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_shouldShowErrorAlertIsPublished_forErrorResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$shouldShowErrorAlert.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
            (100, .input(true)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_repositoryListIsPublished_forNormalResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = makeGitHubRepoItems(withItemCount: 5, totalCount: 5)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber([GitHubRepo].self, Never.self)
        viewModel.$repositoryList.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<[GitHubRepo], Never> = [
            (000, .subscription),
            (000, .input([])),
            (100, .input([])),
            (100, .input(stubModel.data!.items)),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_repositoryListIsPublished_forErrorResponse_whenDidSearchButtonClicked() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber([GitHubRepo].self, Never.self)
        viewModel.$repositoryList.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<[GitHubRepo], Never> = [
            (000, .subscription),
            (000, .input([])),
            (100, .input([])),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_moreSearchResultsExistIsPublished_forResponseWithLargerTotalCount_whenDidSearchButtonClicked() throws {
        stubModel.data = makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$moreSearchResultsExist.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
            (100, .input(false)),
            (100, .input(true)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
}

// MARK: Tests for didPushSearchMore event

extension SearchRepositoriesViewModelTests {
    func test_lastQueryIsNotPublished_whenDidPushSearchMore() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(String?.self, Never.self)
        viewModel.$lastQuery.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<String?, Never> = [
            (000, .subscription),
            (000, .input(nil)),
            (100, .input("Swift")),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_stateIsPublished_forNormalResponse_whenDidPushSearchMore() throws {
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 3, totalCount: 8)
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(
            SearchRepositoriesViewModelState.self,
            Never.self
        )
        viewModel.$state.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<SearchRepositoriesViewModelState, Never> = [
            (000, .subscription),
            (000, .input(.initial)),
            (100, .input(.loading)),
            (100, .input(.ready)),
            (200, .input(.loading)),
            (200, .input(.ready)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_stateIsPublished_forErrorResponse_whenDidPushSearchMore() throws {
        stubModel.data = nil
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = nil
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(
            SearchRepositoriesViewModelState.self,
            Never.self
        )
        viewModel.$state.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<SearchRepositoriesViewModelState, Never> = [
            (000, .subscription),
            (000, .input(.initial)),
            (100, .input(.loading)),
            (100, .input(.ready)),
            (200, .input(.loading)),
            (200, .input(.error)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_shouldShowErrorAlertIsNotPublished_forNormalResponse_whenDidPushSearchMore() throws {
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 3, totalCount: 8)
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$shouldShowErrorAlert.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_shouldShowErrorAlertIsPublished_forNormalResponse_whenDidPushSearchMore() throws {
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = nil
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$shouldShowErrorAlert.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
            (200, .input(true)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_repositoryListIsPublished_forNormalResponse_whenDidPushSearchMore() throws {
        let repoItems1 = makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
        let repoItems2 = makeGitHubRepoItems(withItemCount: 3, totalCount: 8)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = repoItems1
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = repoItems2
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber([GitHubRepo].self, Never.self)
        viewModel.$repositoryList.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<[GitHubRepo], Never> = [
            (000, .subscription),
            (000, .input([])),
            (100, .input([])),
            (100, .input(repoItems1.items)),
            (200, .input(repoItems1.items + repoItems2.items)),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_repositoryListIsPublished_forErrorResponse_whenDidPushSearchMore() throws {
        let repoItems1 = makeGitHubRepoItems(withItemCount: 5, totalCount: 8)
        
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = repoItems1
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = nil
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber([GitHubRepo].self, Never.self)
        viewModel.$repositoryList.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<[GitHubRepo], Never> = [
            (000, .subscription),
            (000, .input([])),
            (100, .input([])),
            (100, .input(repoItems1.items)),
        ]
        XCTAssertEqual(subscriber.recordedOutput, expected)
    }
    
    func test_moreSearchResultsExistIsPublished_forResponseWithLargerTotalCount_whenDidPushSearchMore() throws {
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 12)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 12)
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$moreSearchResultsExist.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
            (100, .input(false)),
            (100, .input(true)),
            (200, .input(true)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
    
    func test_moreSearchResultsExistAsFalseIsPublished_forResponseWithLastSearchResults_whenDidPushSearchMore() throws {
        let scheduler = TestScheduler.init(initialClock: 0)
        scheduler.schedule(after: 100) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 12)
            self.viewModel.send(event: .didSearchButtonClicked(query: "Swift"))
        }
        scheduler.schedule(after: 200) {
            self.stubModel.data = self.makeGitHubRepoItems(withItemCount: 5, totalCount: 10)
            self.viewModel.send(event: .didPushSearchMore)
        }
        
        let subscriber = scheduler.createTestableSubscriber(Bool.self, Never.self)
        viewModel.$moreSearchResultsExist.subscribe(subscriber)
        
        scheduler.resume()
        
        let expected: TestSequence<Bool, Never> = [
            (000, .subscription),
            (000, .input(false)),
            (100, .input(false)),
            (100, .input(true)),
            (200, .input(false)),
        ]
        XCTAssertEqual(expected, subscriber.recordedOutput)
    }
}

// MARK: Private utils

private extension SearchRepositoriesViewModelTests {
    func makeGitHubRepoItems(
        withItemCount count: Int,
        totalCount: Int
    ) -> GitHubRepoItems<GitHubRepo> {
        let items = (0 ..< count).map { i in
            GitHubRepo(id: i, description: "", fullName: "Project \(i)", language: nil, stargazersCount: i, owner: .init(id: i, avatarURL: URL(string: "https://example.com")!), url: URL(string: "https://example.com")!)
        }
        return .init(incompleteResults: false, items: items, totalCount: totalCount)
    }
}

private class GitHubReposModelStub: GitHubReposModelProtocol {
    var data: GitHubRepoItems<GitHubRepo>?
    
    func fetchRepos(withQuery query: String, page: Int, completion: @escaping (GitHubRepoItems<GitHubRepo>?) -> Void) {
        completion(data)
    }
}
