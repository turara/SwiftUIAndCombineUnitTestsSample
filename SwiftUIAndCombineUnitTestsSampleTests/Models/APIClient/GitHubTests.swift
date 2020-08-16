//
//  GitHubTests.swift
//  SwiftUIAndCombineUnitTestsSampleTests
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Moya
@testable import SwiftUIAndCombineUnitTestsSample
import XCTest

class GitHubTests: XCTestCase {
    
    private let provider = MoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub)

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func test_searchRepositoriesResponseIsDecodable() {
        let target = GitHub.searchRepositories(query: "q", page: 1, perPage: 5)
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    XCTAssertNoThrow(
                        try response.map(GitHubRepoItems<GitHubRepo>.self)
                    )
                    // To suppress warnings
                    print(try response.mapJSON())
                } catch {
                    XCTFail(error.localizedDescription)
                }
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
