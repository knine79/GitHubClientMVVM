//
//  UsernameInputViewModel.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import RxSwift

final class UsernameInputViewModel {
    private let repository: RepositoryProtocol
    private let routeSubject = PublishSubject<RoutingScene>()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        if let username = self.username {
            routeSubject.onNext(.gitHubRepositories(.init(username: username)))
        }
    }
    
    func saveUsername(username: String) {
        repository.saveUsername(username: username)
    }
    
    func submitButtonDidTap(username: String) {
        routeSubject.onNext(.gitHubRepositories(.init(username: username)))
    }
    
    var username: String? {
        repository.loadUsername()
    }
    
    var route: Observable<RoutingScene> {
        routeSubject.asObservable()
    }
}
