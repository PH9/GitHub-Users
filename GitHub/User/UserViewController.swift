import UIKit

class UserViewController: UITableViewController {

  let viewModel = UsersViewModel()
  let dataSource = UsersDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    bidingViewModel()
    viewModel.getUsers()
  }

  private func bidingViewModel() {
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
}
