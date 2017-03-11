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
        load(url: URL(string: "https://www.amazon.co.jp/")!)
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
    
    private func load(url: URL) {
        let request = NSURLRequest(url: url) as URLRequest
        webView.load(request)
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
