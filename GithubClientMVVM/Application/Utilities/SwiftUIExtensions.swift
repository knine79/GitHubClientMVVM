//
//  SwiftUIExtensions.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
}
