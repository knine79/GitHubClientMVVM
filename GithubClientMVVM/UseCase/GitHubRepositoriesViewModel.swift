//
//  GitHubRepositoriesViewModel.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/09.
//

import Foundation
import RxSwift

struct GitHubRepositoryItem {
    let name: String
    let cloneUrl: URL
    let language: String?
    let htmlUrl: URL
}

final class GitHubRepositoriesViewModel {
    struct DTOError: Error {
        let message: String
    }
    
    private let repository: RepositoryProtocol
    private(set) var username: String
    
    private let gitHubRepositoriesSubject = PublishSubject<[GitHubRepositoryItem]>()
    private let routeSubject = PublishSubject<RoutingScene>()
    
    init(repository: RepositoryProtocol, username: String) {
        self.repository = repository
        self.username = username
    }
    
    func viewDidAppear() {
        Task {
            try await requestGitHubRepositories()
        }
    }
    
    var gitHubRepositories: Observable<[GitHubRepositoryItem]> {
        gitHubRepositoriesSubject.asObservable()
    }
    
    var avatarUrl: URL? {
        get async {
            do {
                return URL(string: (try await repository.requestUser(username: username)).avatarUrl)
            } catch {
                let context = AlertSceneContext(title: "Error", message: "\(username)이라는 사용자가 없습니다.", buttons: [
                    .init(title: "확인", style: .default) { [weak self] _ in
                        self?.routeSubject.onNext(.common(.pop))
                    }
                ])
                routeSubject.onNext(.common(.alert(context)))
                return nil
            }
        }
    }
    
    func avatarButtonDidTap() {
        routeSubject.onNext(.common(.alert(.init(title: "준비중입니다."))))
    }
    
    var route: Observable<RoutingScene> {
        routeSubject.asObservable()
    }
    
    private func requestGitHubRepositories() async throws {
        let gitHubRepositories = try await repository.requestGitHubRepositories(username: username)
            .map { model in
                guard let cloneUrl = URL(string: model.cloneUrl) else { throw DTOError(message: "cloneUrl is nil") }
                guard let htmlUrl = URL(string: model.htmlUrl) else { throw DTOError(message: "htmlUrl is nil") }
                return GitHubRepositoryItem(name: model.name, cloneUrl: cloneUrl, language: model.language, htmlUrl: htmlUrl)
            }
        gitHubRepositoriesSubject.onNext(gitHubRepositories)
    }
}
