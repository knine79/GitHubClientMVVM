//
//  GitHubRepository.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import Foundation

struct GitHubRepository: Decodable {
    let id: Int
    let nodeId: String
    let name: String
    let fullName: String
    let cloneUrl: String
    let language: String?
    let htmlUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case fullName = "full_name"
        case cloneUrl = "clone_url"
        case language
        case htmlUrl = "html_url"
    }
}
