//
//  Router.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import UIKit
import SwiftUI

class DependencyContainer {
    static let shared = DependencyContainer()
    
    let repository: RepositoryProtocol
    
    private init() {
        let remoteConfig = RemoteConfigurations(hostname: "api.github.com", httpsHeaders: ["Authorization": "Basic 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"])
        let remote = Remote(remoteConfigurations: remoteConfig)
        let cache = Cache()
        repository = Repository(remote: remote, cache: cache)
    }
}

extension RouterProtocol where Self: UIViewController {
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RouterProtocol where Self: UIViewController {
    @discardableResult
    func route(to scene: RoutingScene) -> Bool {
        switch scene {
        case .common(let commonRoutingScene):
            return route(to: commonRoutingScene)
        default:
            return false
        }
    }
    
    @discardableResult
    func route(to scene: CommonRoutingScene) -> Bool {
        switch scene {
        case .pop:
            popViewController()
            return true
        case .alert(let context):
            let alert = UIAlertController(title: context.title, message: context.message, preferredStyle: .alert)
            if context.buttons.isEmpty {
                alert.addAction(UIAlertAction(title: "확인", style: .default))
            } else {
                context.buttons.forEach {
                    alert.addAction(UIAlertAction(title: $0.title, style: $0.style, handler: $0.action))
                }
            }
            navigationController?.topViewController?.present(alert, animated: true)
            return true
        }
    }
}

extension AppDelegate: UsernameInputViewControllerBuildable {}
extension RouterProtocol where Self: AppDelegate & UsernameInputViewControllerBuildable {
    func setRootViewConrller(_ viewController: UIViewController) {
        window?.rootViewController = UINavigationController(rootViewController: viewController)
    }
    
    @discardableResult
    func route(to scene: RoutingScene) -> Bool {
        switch scene {
        case .usernameInput:
            let viewController = buildUsernameInputViewController()
            setRootViewConrller(viewController)
            return true
        default:
            return false
        }
    }
}

extension UsernameInputViewController: GitHubRepositoriesViewBuildable {}
extension RouterProtocol where Self: UsernameInputViewController & GitHubRepositoriesViewBuildable {
    
    @discardableResult
    func route(to scene: RoutingScene) -> Bool {
        switch scene {
        case .common(let commonRoutingScene):
            return route(to: commonRoutingScene)
        case .gitHubRepositories(let context):
            let viewController = buildGitHubRepositoriesViewController(username: context.username)
            pushViewController(viewController)
            return true
        default:
            return false
        }
    }
}
