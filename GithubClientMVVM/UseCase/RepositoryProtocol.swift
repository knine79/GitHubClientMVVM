//
//  RepositoryProtocol.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import Foundation

protocol RepositoryProtocol {
    func requestUser(username: String) async throws -> User
    func requestGitHubRepositories(username: String) async throws -> [GitHubRepository]
    func loadUsername() -> String?
    func saveUsername(username: String?)
}
