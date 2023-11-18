import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        if let selectedWebsite = self.selectedWebsite {
            if let url = URL(string: "https://" + selectedWebsite) {
                webView.load(URLRequest(url: url))
            }
        }
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //@objc func openTapped() {
    //    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    //    for website in websites {
    //        ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    //    }
    //    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    //    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    //    present(ac, animated: true)
    //}
    
    //func openPage(action: UIAlertAction) {
    //    guard let actionTitle = action.title else { return }
    //    guard let url = URL(string: "https://" + actionTitle) else { return }
    //    webView.load(URLRequest(url: url))
    //}
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            if let selectedWebsite = self.selectedWebsite {
                if host.contains(selectedWebsite) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        let ac = UIAlertController(title: "Access Denied", message: "This website is blocked.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}
