# ios-uikit-wkwebview-demo
iOS WKWebViewを利用したサンプル(Swift3)

※Storyboardを利用した実装ができない

## 実装サンプル

```
import UIKit
import WebKit

final class ViewController: UIViewController {
    
    var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        loadFirstPage()
    }
    
    private func setup() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        
        goBackButton.isEnabled = false
        goForwordButton.isEnabled = false
    }
    
    private func layout() {
        self.view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0)
            .isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -44.0)
            .isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0)
            .isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
            .isActive = true
    }
    
    private func loadFirstPage() {
        if let htmlData = Bundle.main.path(forResource: "index", ofType: "html") {
            webView.load(URLRequest(url: URL(fileURLWithPath: htmlData)))
            self.view.addSubview(webView)
        } else {
            print("file not found")
        }
    }

    @IBAction func goBackButton(_ sender: UIBarButtonItem) {
        if webView.canGoBack { webView.goBack() }
    }
    
    @IBAction func goForwordButton(_ sender: UIBarButtonItem) {
        if webView.canGoForward { webView.goForward() }
    }
}

extension ViewController: WKNavigationDelegate {
    
    /// ページ読み込み完了時、呼ばれるメソッド
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        goBackButton.isEnabled = webView.canGoBack
        goForwordButton.isEnabled = webView.canGoForward
    }
    
    /// target="_blank"を開けるようにする
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        // target="_blank"の場合
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if navigationAction.targetFrame == nil || !(navigationAction.targetFrame!.isMainFrame) {
                webView.load(NSURLRequest.init(url: url) as URLRequest)
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
}
```

### iOS11 カスタムURLのフック方法
①カスタムハンドラーをWKWebViewに設定する

```
    private func setup() {
        
        let conf = WKWebViewConfiguration()
        conf.setURLSchemeHandler(URLSchemeHandler(), forURLScheme: Constants.customURLScheme)
        
        webView = WKWebView(frame:CGRect.zero, configuration: conf)
    }
```

②カスタムURLを受信すると、フックする処理を追加する
```
import WebKit

final class URLSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        guard let url = urlSchemeTask.request.url else {
            return
        }
        URLMatcher.match(url).action()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        urlSchemeTask.didFailWithError(WebErrors.RequestFailedError)
    }
}

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
```
