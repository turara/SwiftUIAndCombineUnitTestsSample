//
//  GitHubRepoItems.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Foundation

struct GitHubRepoItems<Item: Decodable>: Decodable {
    let incompleteResults: Bool
    let items: [Item]
    let totalCount: Int

    private enum CodingKeys: String, CodingKey {
        case incompleteResults = "incomplete_results"
        case items
        case totalCount = "total_count"
    }
}
