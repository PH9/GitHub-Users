import UIKit

class ErrorCell: UITableViewCell {

  @IBOutlet weak var messageLabel: UILabel!

  func configureWith(message: String) {
    messageLabel.text = message
  }

}
