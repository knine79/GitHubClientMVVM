//
//  Remote.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import Foundation

extension Remote {
    func requestUser(username: String) async throws -> User {
        try await request(endpoint: "/users/\(username)")
    }
    
    func requestGitHubRepositories(username: String) async throws -> [GitHubRepository] {
        try await request(endpoint: "/users/\(username)/repos")
    }
}
