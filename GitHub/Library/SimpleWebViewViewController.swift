import UIKit
import WebKit

class SimpleWebViewViewController: UIViewController, WKNavigationDelegate {

  private let webView = WKWebView()

  override func loadView() {
    super.loadView()
    webView.navigationDelegate = self
    view = webView
  }

  func configureWith(url: String) {
    let url = URL(string: url)!
    webView.load(URLRequest(url: url))
  }

}
