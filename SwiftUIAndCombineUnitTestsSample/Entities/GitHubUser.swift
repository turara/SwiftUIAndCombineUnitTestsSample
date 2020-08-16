//
//  GitHubUser.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/16.
//  Copyright © 2020 Turara. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    let id: Int
    let avatarURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
    }
    
    init(id: Int, avatarURL: URL) {
        self.id = id
        self.avatarURL = avatarURL
    }
}

