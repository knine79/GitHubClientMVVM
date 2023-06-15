//
//  RouterProtocol.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import UIKit

enum RoutingScene {
    case common(CommonRoutingScene)
    case usernameInput
    case gitHubRepositories(GitHubRepositoriesSceneContext)
}

enum CommonRoutingScene {
    case pop
    case alert(AlertSceneContext)
}

struct AlertSceneContext {
    struct Button {
        let title: String
        let style: UIAlertAction.Style
        let action: ((UIAlertAction) -> Void)?
    }
    let title: String
    let message: String?
    let buttons: [Button]
    
    init(title: String, message: String? = nil, buttons: [Button] = []) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

struct GitHubRepositoriesSceneContext {
    let username: String
}

protocol RouterProtocol {
    @discardableResult
    func route(to scene: RoutingScene) -> Bool
}
