import UIKit

class FetchingCell: UITableViewCell {

  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    activityIndicatorView.startAnimating()
  }

  static var reusableIdentifier: String {
    String(describing: self)
  }
}
