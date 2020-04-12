import UIKit
import Kingfisher

class UserCell: UITableViewCell {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var accountTypeHeaderLabel: UILabel!
  @IBOutlet weak var accountTypeLabel: UILabel!
  @IBOutlet weak var adminStatusHeaderLabel: UILabel!
  @IBOutlet weak var adminStatusLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  @IBOutlet var regularConstraints: [NSLayoutConstraint]!
  @IBOutlet var commonConstrains: [NSLayoutConstraint]!
  private var largeTextConstraints: [NSLayoutConstraint] = []

  override func awakeFromNib() {
    super.awakeFromNib()
    createConstrantsForAccessibilityCategory()
    updateLayoutConstraints()
  }

  private func createConstrantsForAccessibilityCategory() {
    largeTextConstraints = [
      avatarImage.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      avatarImage.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      avatarImage.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

      usernameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
      usernameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 0),
      usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),

      urlLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
      urlLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      urlLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),

      accountTypeHeaderLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
      accountTypeHeaderLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      accountTypeHeaderLabel.trailingAnchor.constraint(equalTo: urlLabel.trailingAnchor),

      accountTypeLabel.topAnchor.constraint(equalTo: accountTypeHeaderLabel.bottomAnchor, constant: 8),
      accountTypeLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      accountTypeLabel.trailingAnchor.constraint(equalTo: accountTypeHeaderLabel.trailingAnchor),

      adminStatusHeaderLabel.topAnchor.constraint(equalTo: accountTypeLabel.bottomAnchor, constant: 8),
      adminStatusHeaderLabel.leadingAnchor.constraint(equalTo: accountTypeLabel.leadingAnchor),
      adminStatusHeaderLabel.trailingAnchor.constraint(equalTo: accountTypeLabel.trailingAnchor),

      adminStatusLabel.topAnchor.constraint(equalTo: adminStatusHeaderLabel.bottomAnchor, constant: 8),
      adminStatusLabel.leadingAnchor.constraint(equalTo: adminStatusHeaderLabel.leadingAnchor),
      adminStatusLabel.trailingAnchor.constraint(equalTo: adminStatusHeaderLabel.trailingAnchor)
    ]
  }

  @IBAction func favoriteButtonTapped(_ sender: Any) {
    // TODO: Favorite and unfavorite
  }

  func configureWith(user: User) {
    avatarImage.kf.setImage(with: URL(string: user.avatar_url)!)
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

  private func updateLayoutConstraints() {
    NSLayoutConstraint.activate(commonConstrains)

    if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
      NSLayoutConstraint.deactivate(regularConstraints)
      NSLayoutConstraint.activate(largeTextConstraints)
    } else {
      NSLayoutConstraint.deactivate(largeTextConstraints)
      NSLayoutConstraint.activate(regularConstraints)
    }
  }

}
