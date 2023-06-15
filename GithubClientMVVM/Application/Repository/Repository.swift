//
//  Repository.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/09.
//

import Foundation

final class Repository {
    private let remote: Remote
    private let cache: Cache
    
    init(remote: Remote, cache: Cache) {
        self.remote = remote
        self.cache = cache
    }
}

extension Repository: RepositoryProtocol {
    func requestUser(username: String) async throws -> User {
        try await remote.requestUser(username: username)
    }
    
    func requestGitHubRepositories(username: String) async throws -> [GitHubRepository] {
        try await remote.requestGitHubRepositories(username: username)
    }
    
    func loadUsername() -> String? {
        cache.loadUsername()
    }
    
    func saveUsername(username: String?) {
        cache.saveUsername(username: username)
    }
}
