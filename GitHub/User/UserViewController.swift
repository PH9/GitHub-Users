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
    dataSource.replace(users: users)
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
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
