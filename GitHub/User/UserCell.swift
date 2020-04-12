import UIKit

class UserCell: UITableViewCell {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var accountTypeLabel: UILabel!
  @IBOutlet weak var adminStatusLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  @IBAction func favoriteButtonTapped(_ sender: Any) {
  }

  static var reusableIdentifier: String {
    String(describing: self)
  }

}
