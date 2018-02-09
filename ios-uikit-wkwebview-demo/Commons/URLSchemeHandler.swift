//
//  URLSchemeHandler.swift
//  ios-uikit-wkwebview-demo
//
//  Created by Eiji Kushida on 2018/02/07.
//  Copyright © 2018年 Kushida　Eiji. All rights reserved.
//

import WebKit

final class URLSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        guard let url = urlSchemeTask.request.url else {
            return
        }
        URLMatcher.match(url).action()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
    }
}
