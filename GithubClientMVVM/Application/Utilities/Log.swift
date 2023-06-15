//
//  Log+SwiftUI.swift
//  SharedFrameworks
//
//  Created by Samuel on 2022/03/16.
//

import SwiftUI

public struct SULog: View {
    init(_ logMessage: Any) {
        printLog(logMessage)
    }
    
    public var body: some View {
        EmptyView()
    }
}

func printLog(_ items: Any) {
    #if DEBUG
    print(items)
    #endif
}
