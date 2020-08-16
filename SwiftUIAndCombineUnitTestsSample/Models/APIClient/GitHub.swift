//
//  GitHub.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Foundation
import Moya

enum GitHub {
    case searchRepositories(query: String, page: Int, perPage: Int = 5)
}

extension GitHub: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "/search/repositories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchRepositories:
            return .get
        }
    }
    
    var sampleData: Data {
        sampleDataString?.data(using: .utf8) ?? Data()
    }
    
    var task: Task {
        switch self {
        case let .searchRepositories(query: query, page: page, perPage: perPage):
            return .requestParameters(
                parameters: [
                    "q": query,
                    "page": page,
                    "per_page": perPage,
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        ["accept": "application/vnd.github.v3+json"]
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}

private extension GitHub {
    var sampleDataString: String? {
        switch self {
        case .searchRepositories:
            return """
            {
            "incomplete_results\": false,
            \"items\": [
            {
            \"description\": \"Description of Awesome Project 1\",
            \"full_name\": \"Awesome Project 1\",
            \"id\": 1,
            \"language\": \"C++\",
            \"owner\": {
            \"avatar_url\": \"https://example.com\",
            \"id\": 1
            },
            \"stargazers_count\": 20000,
            \"url\": \"https://example.com\"
            },
            {
            \"description\": \"Description of Ordinary Project 2\",
            \"full_name\": \"Ordinary Project 1\",
            \"id\": 2,
            \"language\": \"Swift\",
            \"owner\": {
            \"avatar_url\": \"https://example.com\",
            \"id\": 2
            },
            \"stargazers_count\": 100,
            \"url\": \"https://example.com\"
            },
            {
            \"description\": \"Description of Project 3\",
            \"full_name\": \"Project 3\",
            \"id\": 3,
            \"language\": \"Python\",
            \"owner\": {
            \"avatar_url\": \"https://example.com\",
            \"id\": 3
            },
            \"stargazers_count\": 50,
            \"url\": \"https://example.com\"
            },
            {
            \"description\": \"Description of Project 4\",
            \"full_name\": \"Project 4\",
            \"id\": 4,
            \"language\": \"Swift\",
            \"owner\": {
            \"avatar_url\": \"https://example.com\",
            \"id\": 4
            },
            \"stargazers_count\": 10,
            \"url\": \"https://example.com\"
            },
            {
            \"description\": \"Description of Project 5\",
            \"full_name\": \"Ordinary Project 5\",
            \"id\": 5,
            \"language\": \"Ruby\",
            \"owner\": {
            \"avatar_url\": \"https://example.com\",
            \"id\": 5
            },
            \"stargazers_count\": 1000,
            \"url\": \"https://example.com\"
            }
            ],
            \"total_count\": 8
            }
            """
        }
    }
}
