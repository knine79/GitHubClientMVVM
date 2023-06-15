//
//  UIKitExtensions.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import UIKit

extension Array where Element == NSLayoutConstraint {
    func activate() {
        forEach {
            $0.isActive = true
        }
    }
}
