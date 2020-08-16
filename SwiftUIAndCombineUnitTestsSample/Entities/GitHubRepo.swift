//
//  GitHubRepo.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Foundation

struct GitHubRepo: Codable {
    let id: Int
    let description: String
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let owner: GitHubUser
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case owner
        case url
    }
}

extension GitHubRepo: Equatable {
    static func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
        lhs.id == rhs.id
    }
}
