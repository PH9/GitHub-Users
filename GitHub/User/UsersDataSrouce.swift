import UIKit

protocol UsersDataSourceDelegate: class {
  func usersDataSource(wantToFetchNewUser atId: Int)
}

class UsersDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {

  private(set) var users: [User] = []
  weak var delegeate: UsersDataSourceDelegate?

  func replace(users: [User]) {
    self.users = users
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return 0
    }

    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: FetchingCell.reusableIdentifier, for: indexPath) as? FetchingCell else {
          fatalError("Could not dequeue \(FetchingCell.reusableIdentifier) for \(indexPath)")
      }

      return cell
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reusableIdentifier, for: indexPath)
      as? UserCell else {
        fatalError("Could not dequque \(UserCell.reusableIdentifier) for \(indexPath)")
    }

    let index = indexPath.row
    let user = users[index]
    cell.configureWith(user: user)
    prefetchNewDataIfNeeded(index: index)

    return cell
  }

  private func prefetchNewDataIfNeeded(index: Int) {
    guard index >= users.count - 5 else {
      return
    }

    guard let nextId = users.last?.id else {
      return
    }

    delegeate?.usersDataSource(wantToFetchNewUser: nextId)
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let urls = indexPaths.compactMap { URL(string: users[$0.row].avatar_url) }
    ImagePrefetcher(urls: urls).start()
  }

}
