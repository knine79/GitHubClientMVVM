//
//  Cache.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import Foundation

enum CacheKey: String {
    case username
}

final class Cache {
    func loadUsername() -> String? {
        UserDefaults.standard.string(forKey: CacheKey.username.rawValue)
    }
    
    func saveUsername(username: String?) {
        if username?.isEmpty == false {
            UserDefaults.standard.set(username, forKey: CacheKey.username.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: CacheKey.username.rawValue)
        }
    }
}
