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
  private var largeTextConstraints: [NSLayoutConstraint] = []
  private var user: User!

  override func awakeFromNib() {
    super.awakeFromNib()
    createConstrantsForAccessibilityCategory()
    updateLayoutConstraints()
  }

  private func createConstrantsForAccessibilityCategory() {
    largeTextConstraints = [
      avatarImage.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      usernameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 4),
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
      accountTypeLabel.topAnchor.constraint(equalTo: accountTypeHeaderLabel.bottomAnchor, constant: 4),
      accountTypeLabel.leadingAnchor.constraint(equalTo: accountTypeHeaderLabel.leadingAnchor),
      adminStatusLabel.topAnchor.constraint(equalTo: adminStatusHeaderLabel.bottomAnchor, constant: 4),
      adminStatusLabel.leadingAnchor.constraint(equalTo: adminStatusHeaderLabel.leadingAnchor)
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
    favoriteButton.setTitle("", for: .normal)
    let heart = UIImage(named: "Heart")!.withRenderingMode(.alwaysTemplate)
    favoriteButton.setImage(heart, for: .normal)
    let color: UIColor = isFavorite ? .systemRed : .systemGray
    favoriteButton.tintColor = color
  }

  private func toggleFavoriteBy(userId: Int) {
    let key = generateFavoriteKey(userId: userId)
    let isFavorite = !UserDefaults.standard.bool(forKey: key)
    UserDefaults.standard.set(isFavorite, forKey: key)
  }

  private func generateFavoriteKey(userId: Int) -> String {
    return "favorite-user-id-\(userId)"
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(false, animated: animated)
  }

  private func updateLayoutConstraints() {
    if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
      NSLayoutConstraint.deactivate(regularConstraints)
      NSLayoutConstraint.activate(largeTextConstraints)
    } else {
      NSLayoutConstraint.deactivate(largeTextConstraints)
      NSLayoutConstraint.activate(regularConstraints)
    }
  }

}
