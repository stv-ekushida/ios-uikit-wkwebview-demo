//
//  URLMatcher.swift
//  ios-uikit-wkwebview-demo
//
//  Created by Eiji Kushida on 2018/02/07.
//  Copyright © 2018年 Kushida　Eiji. All rights reserved.
//

import Foundation

enum HandlerType {
    case none
    case hook([String: String])
    
    func action() {
        switch self {
        case .hook(let params):
            hookUrlSchme(params)
        case .none:
            break
        }
    }
    
    /// URLスキームでフックしたときにやりたい処理
    ///
    /// - Parameter params: <#params description#>
    private func hookUrlSchme(_ params: [String : String]) {
        print("hook url scheme")
        
        params.forEach {
            print("\($0.key) : \($0.value)")
        }
    }
}

final class URLMatcher {
    
    static func match(_ url: URL) -> HandlerType {
        
        if url.scheme == Constants.customURLScheme {
            
            var params: [String : String] = [:]
            
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                for queryParams in queryItems {
                    params[queryParams.name] = queryParams.value
                }
            }
            return .hook(params)
        }
        return .none
    }
}
