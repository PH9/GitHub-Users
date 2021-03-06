import UIKit

class UsersDataSource: NSObject, UITableViewDataSource {

  enum Section: Int {
    case user
    case fetching
  }

  private(set) var values: [[Any]] = [[]]

  func replace(users: [User]) {
    values.removeAll()
    values.insert(users, at: Section.user.rawValue)
  }

  func showFetchingCell() {
    addEmptySection(section: Section.fetching.rawValue)
    values.insert([true], at: Section.fetching.rawValue)
  }

  func addEmptySection(section: Int) {
    guard self.values.count <= section else { return }
    (self.values.count...section).forEach { _ in
      self.values.append([])
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return values.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return values[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let value = values[indexPath.section][indexPath.row]

    if indexPath.section == Section.user.rawValue {
      let cell = tableView.dequeue(UserCell.self, for: indexPath)

      let user = value as? User
      cell.configureWith(user: user!)

      return cell
    }

    if indexPath.section == Section.fetching.rawValue {
      let cell = tableView.dequeue(FetchingCell.self, for: indexPath)
      cell.activityIndicatorView.startAnimating()
      return cell
    }

    fatalError("Unimplemented \(indexPath)")
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let urls = indexPaths.compactMap { indexPath -> URL? in
      if indexPath.section == Section.user.rawValue,
        let user = values[Section.user.rawValue][indexPath.row] as? User {
        return URL(string: user.avatar_url)
      }

      return nil
    }

    ImagePrefetcher(urls: urls).start()
  }

}
