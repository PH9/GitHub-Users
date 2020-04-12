import UIKit

class ActivityIndicator {

  static let shared = ActivityIndicator()

  private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

  init() {
    activityIndicator.hidesWhenStopped = true
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    activityIndicator.backgroundColor = .init(white: 0, alpha: 0.7)
    activityIndicator.layer.cornerRadius = 10
    activityIndicator.clipsToBounds = true
  }

  static func show(to view: UIView) {
    shared.activityIndicator.center = view.center
    shared.activityIndicator.startAnimating()
    view.addSubview(shared.activityIndicator)
  }

  static func dismiss() {
    shared.activityIndicator.startAnimating()
    shared.activityIndicator.removeFromSuperview()
  }
}
