import UIKit

protocol ErrorFullPageDelegate: class {

  func errorFullPageSendSignalToRetry()
}

class ErrorFullPageViewController: UIViewController {

  @IBOutlet weak var messageLabel: UILabel!

  weak var delegate: ErrorFullPageDelegate?

  static func instantiate(message: String) -> ErrorFullPageViewController {
    let storybaord = UIStoryboard(name: "ErrorFullPage", bundle: nil)
    let identifier = String(describing: self)
    guard let vc = storybaord.instantiateViewController(
      withIdentifier: identifier) as? ErrorFullPageViewController else {
        fatalError("Could not instantiate \(identifier)")
    }

    _ = vc.view
    vc.messageLabel.text = message
    return vc
  }

  @IBAction func retry(_ sender: Any) {
    delegate?.errorFullPageSendSignalToRetry()
  }
}
