//
//  DummyRepository.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import Foundation

final class DummyRepository: RepositoryProtocol {
    func requestUser(username: String) async throws -> User {
        User(login: "", avatarUrl: "", name: nil)
    }
    
    func requestGitHubRepositories(username: String) async throws -> [GitHubRepository] {
        []
    }
    
    func loadUsername() -> String? {
        nil
    }
    
    func saveUsername(username: String?) {
    }
}
