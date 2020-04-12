import UIKit

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
  private var user: User!

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
    toggleFavoriteBy(userId: user.id)
    setButtonTitleBy(userId: user.id)
  }

  func configureWith(user: User) {
    self.user = user
    avatarImage.setImage(url: URL(string: user.avatar_url)!)
    usernameLabel.text = user.login
    urlLabel.text = user.html_url
    accountTypeLabel.text = user.type
    adminStatusLabel.text = String(user.site_admin)
    setButtonTitleBy(userId: user.id)
  }

  private func setButtonTitleBy(userId: Int) {
    let isFavorite = UserDefaults.standard.bool(forKey: generateFavoriteKey(userId: user.id))
    let buttonTitle = getButtonTitle(isFavorite: isFavorite)
    favoriteButton.setTitle(buttonTitle, for: .normal)
  }

  private func toggleFavoriteBy(userId: Int) {
    let key = generateFavoriteKey(userId: userId)
    let isFavorite = !UserDefaults.standard.bool(forKey: key)
    UserDefaults.standard.set(isFavorite, forKey: key)
  }

  private func generateFavoriteKey(userId: Int) -> String {
    return "favorite-user-id-\(userId)"
  }

  private func getButtonTitle(isFavorite: Bool) -> String {
    return isFavorite ? "Unfavorite" : "Favorite"
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
