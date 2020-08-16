//
//  GitHubReposModelTests.swift
//  SwiftUIAndCombineUnitTestsSampleTests
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Moya
@testable import SwiftUIAndCombineUnitTestsSample
import XCTest

class GitHubReposModelTests: XCTestCase {
    
    var model: GitHubReposModel!

    override func setUpWithError() throws {
        let stubClient = MoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub)
        model = GitHubReposModel(apiClient: stubClient)
    }

    override func tearDownWithError() throws {}
    
    func test_fetchReposReturnsRepoItems() {
        let exp = expectation(description: "RepoItems not nil")
        model.fetchRepos(withQuery: "q", page: 1) { repoItems in
            XCTAssertNotNil(repoItems)
            XCTAssertEqual(repoItems?.items.count, 5)
            XCTAssertEqual(repoItems?.totalCount, 8)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_fetchReposReturnsNil_whenSomeErrorOccurs() {
        makeModelWithErrorStub()
        let exp = expectation(description: "RepoItems nil")
        model.fetchRepos(withQuery: "q", page: 1) { repoItems in
            XCTAssertNil(repoItems)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    private func makeModelWithErrorStub() {
        let customEndpointClosure = { (target: GitHub) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(500, Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        let errorStub = MoyaProvider<GitHub>(
            endpointClosure: customEndpointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )
        model = GitHubReposModel(apiClient: errorStub)
    }

}
