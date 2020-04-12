import UIKit

class UserCell: UITableViewCell {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var accountTypeLabel: UILabel!
  @IBOutlet weak var adminStatusLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  @IBAction func favoriteButtonTapped(_ sender: Any) {
    // TODO: Favorite and unfavorite
  }

  func configureWith(user: User) {
    // TODO: Set avatar image
    usernameLabel.text = user.login
    urlLabel.text = user.html_url
    accountTypeLabel.text = user.type
    adminStatusLabel.text = String(user.site_admin)
  }

  static var reusableIdentifier: String {
    String(describing: self)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(false, animated: animated)
  }
}
