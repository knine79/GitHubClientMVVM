//
//  GitHubRepositoryItemCell.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/14.
//

import SwiftUI

final class GitHubRepositoryItemCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentConfiguration = nil
    }
    
    func configure(item: GitHubRepositoryItem) {
        backgroundColor = .clear
        contentConfiguration = UIHostingConfiguration {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 18, weight: .bold))
                Text(item.cloneUrl.absoluteString)
                    .font(.system(size: 12))
                if let language = item.language {
                    HStack(alignment: .center) {
                        if let url = lnaguageLogoURL(language) {
                            CachedAsyncImage(url: url) {
                                if let image = $0.image {
                                    image.resizable().frame(width: 16, height: 16)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                } else if let _ = $0.error {
                                    EmptyView()
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                        Text(language)
                            .font(.system(size: 14))
                    }
                    .frame(height: 16)
                }
            }
            .padding(8)
        }
    }
    
    func lnaguageLogoURL(_ language: String) -> URL? {
        URL(string: "https://github.com/abrahamcalf/programming-languages-logos/blob/master/src/\(language.lowercased())/\(language.lowercased())_32x32.png?raw=true")
    }
}
