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
    case stv([String: String])
    case sdt([String: String])
    
    func action() {
        switch self {
        case .stv(let params):
            hookUrlSchmeA(params)
        case .sdt(let params):
            hookUrlSchmeB(params)
        case .none:
            break
        }
    }
    
    /// URLスキームでフックしたときにやりたい処理
    ///
    /// - Parameter params: パラメタ
    private func hookUrlSchmeA(_ params: [String : String]) {
        print("hook url scheme stv")
    }
    
    /// URLスキームでフックしたときにやりたい処理
    ///
    /// - Parameter params: パラメタ
    private func hookUrlSchmeB(_ params: [String : String]) {
        print("hook url scheme sdt")
    }
}

final class URLMatcher {
    
    /// URLスキーム毎に処理を分ける
    ///
    /// - Parameter url: URLスキーム
    /// - Returns: URLスキームの種別
    static func match(_ url: URL) -> HandlerType {
        
        guard let scheme = url.scheme else {
            return .none
        }        
        switch scheme {
        case Constants.customURLSchemeA:
            return .stv(URLMatcher.parseParameter(url: url))
        case Constants.customURLSchemeB:
            return .sdt(URLMatcher.parseParameter(url: url))
        default:
            return .none
        }
    }
    
    /// クエリのパラメタを抽出する
    ///
    /// - Parameter url: URLスキーム
    /// - Returns: パラメタの辞書リスト
    static func parseParameter(url: URL) -> [String: String]{
        var params: [String : String] = [:]
        
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
            for queryParams in queryItems {
                params[queryParams.name] = queryParams.value
            }
        }
        return params
    }
}
