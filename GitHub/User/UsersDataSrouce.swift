import UIKit

class UsersDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {

  enum Section: Int {
    case user
    case fetching
    case error
  }

  private(set) var values: [[Any]] = []
  private var isFetching = true
  private var errorMessage: String?

  func replace(users: [User]) {
    values.removeAll()
    values.insert(users, at: Section.user.rawValue)
  }

  func showFetchingCell() {
    addEmptySection(section: Section.error.rawValue)
    values.insert([true], at: Section.fetching.rawValue)
  }

  func showErrorCell(message: String) {
    addEmptySection(section: Section.error.rawValue)
    values.insert([message], at: Section.error.rawValue)
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

    fatalError("Not implemented yet!")
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

extension UITableViewCell {

  static var reusableIdentifier: String {
    String(describing: self)
  }
}

extension UITableView {

  func dequeue<CellType: UITableViewCell>(_ cellType: CellType.Type, for indexPath: IndexPath) -> CellType {
    guard let cell = dequeueReusableCell(
      withIdentifier: cellType.reusableIdentifier,
      for: indexPath) as? CellType else {
        fatalError("Could not dequeue \(cellType.reusableIdentifier)")
    }

    return cell
  }
}
