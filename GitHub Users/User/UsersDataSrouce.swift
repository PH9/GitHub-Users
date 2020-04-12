import UIKit

class UsersDataSource: NSObject, UITableViewDataSource {

  private var users: [User] = []

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubUserCell.reusableIdentifier, for: indexPath)
      as? GitHubUserCell else {
      fatalError("Could not dequque \(GitHubUserCell.reusableIdentifier) for \(indexPath)")
    }

    return cell
  }
}
