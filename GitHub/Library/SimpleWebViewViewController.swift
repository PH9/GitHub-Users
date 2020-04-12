import UIKit
import WebKit

class SimpleWebViewViewController: UIViewController, WKNavigationDelegate {

  private let webView = WKWebView()

  override func loadView() {
    super.loadView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupToolBar()
  }

  func configureWith(url: String) {
    let url = URL(string: url)!
    webView.load(URLRequest(url: url))
  }

  fileprivate func setupToolBar() {
    let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismiss(_:)))
    let toolBar = UIToolbar()
    toolBar.isTranslucent = false
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBar.items = [closeButton]
    webView.addSubview(toolBar)

    let constraints = [
      toolBar.bottomAnchor.constraint(equalTo: webView.layoutMarginsGuide.bottomAnchor, constant: 0),
      toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0),
      toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  @objc private func dismiss(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
