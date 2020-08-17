//
//  GitHubReposModel.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Foundation
import Moya

protocol GitHubReposModelProtocol {
    func fetchRepos(
        withQuery query: String,
        page: Int,
        completion: @escaping (GitHubRepoItems<GitHubRepo>?) -> Void
    )
}

class GitHubReposModel {
    private let apiClient: MoyaProvider<GitHub>
    private var cancellable: Moya.Cancellable?
    
    init(apiClient: MoyaProvider<GitHub>) {
        self.apiClient = apiClient
    }
    
    deinit {
        cancellable?.cancel()
    }
}

extension GitHubReposModel: GitHubReposModelProtocol {
    func fetchRepos(withQuery query: String, page: Int, completion: @escaping (GitHubRepoItems<GitHubRepo>?) -> Void) {
        cancellable?.cancel()
        let target = GitHub.searchRepositories(query: query, page: page, perPage: 5)
        cancellable = apiClient.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let repoItems = try response.map(GitHubRepoItems<GitHubRepo>.self)
                    completion(repoItems)
                } catch {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
}

#if DEBUG
extension GitHubReposModel {
    // For previews
    static func makeModelWithStub() -> GitHubReposModel {
        .init(apiClient: .init(stubClosure: MoyaProvider.delayedStub(2)))
    }
}
#endif
