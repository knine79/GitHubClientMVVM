//
//  User.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/13.
//

import Foundation

struct User {
    let login: String
    let avatarUrl: String
    let name: String?
}

extension User: Decodable {
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
    }
}
