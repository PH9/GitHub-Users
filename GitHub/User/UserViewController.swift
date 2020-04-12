import UIKit

class UserViewController: UITableViewController {

  var viewModel = UsersViewModel()
  let dataSource = UsersDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    binding()
    viewModel.getUsers()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 172.5
  }

  private func binding() {
    dataSource.delegeate = self
    tableView.dataSource = dataSource
    tableView.prefetchDataSource = dataSource
    viewModel.getUserSuccess = getUsersSuccess(_:)
    viewModel.getUserFailure = getUsersFailure(_:)
  }

  private func getUsersSuccess(_ users: [User]) {
    defer {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }

    if users.count == 0 {
      emptyUserHandler()
      return
    }
    dataSource.replace(users: users)
  }

  private func emptyUserHandler() {
    let size = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    let messageLabel = UILabel(frame: rect)
    messageLabel.text = "GitHub have no user"
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.font = .preferredFont(forTextStyle: .body)
    messageLabel.sizeToFit()
    messageLabel.adjustsFontForContentSizeCategory = true

    tableView.backgroundView = messageLabel
    tableView.separatorStyle = .none
  }

  private func getUsersFailure(_ error: AppError) {
    print(error)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let url = dataSource.users[indexPath.row].html_url
    presentWebViewFrom(url: url)
  }

  private func presentWebViewFrom(url: String) {
    let webView = SimpleWebViewViewController()
    webView.configureWith(url: url)

    present(webView, animated: true, completion: nil)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    tableView.reloadData()
  }

}

extension UserViewController: UsersDataSourceDelegate {

  func usersDataSource(wantToFetchNewUser atId: Int) {
    viewModel.getUsers(sinceId: atId)
  }

}
