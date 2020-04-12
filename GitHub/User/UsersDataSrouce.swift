import UIKit

class UsersDataSource: NSObject, UITableViewDataSource {

  private var users: [User] = []

  func replace(users: [User]) {
    self.users = users
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reusableIdentifier, for: indexPath)
      as? UserCell else {
        fatalError("Could not dequque \(UserCell.reusableIdentifier) for \(indexPath)")
    }

    let user = users[indexPath.row]
    cell.configureWith(user: user)

    return cell
  }

}
