//
//  ViewControllerBuilder.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import Foundation

protocol DependencyContainerAccessible {}
extension DependencyContainerAccessible {
    var dependencies: DependencyContainer {
        DependencyContainer.shared
    }
}

protocol UsernameInputViewControllerBuildable: DependencyContainerAccessible {}
extension UsernameInputViewControllerBuildable {
    func buildUsernameInputViewController() -> UsernameInputViewController {
        let viewModel = UsernameInputViewModel(repository: dependencies.repository)
        return UsernameInputViewController(viewModel: viewModel)
    }
}
protocol GitHubRepositoriesViewBuildable: DependencyContainerAccessible {}
extension GitHubRepositoriesViewBuildable {
    func buildGitHubRepositoriesViewController(username: String) -> GitHubRepositoriesViewController {
        let viewModel = GitHubRepositoriesViewModel(repository: dependencies.repository, username: username)
        return GitHubRepositoriesViewController(viewModel: viewModel)
    }
}
