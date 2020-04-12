import UIKit

class UserViewController: UITableViewController {

  var viewModel = UsersViewModel()
  let dataSource = UsersDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    binding()
    registerCell()
    viewModel.getUsers()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 172.5
  }

  private func binding() {
    tableView.dataSource = dataSource
    tableView.prefetchDataSource = dataSource
    viewModel.getUserSuccess = getUsersSuccess(_:)
    viewModel.getUserFailure = getUsersFailure(_:)
  }

  private func registerCell() {
    let nib = UINib(nibName: FetchingCell.reusableIdentifier, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: FetchingCell.reusableIdentifier)
  }

  private func getUsersSuccess(_ users: [User]) {
    defer {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }

    if users.count == 0 {
      showFullPage(message: "GitHub have no user")
      return
    }
    dataSource.replace(users: users)
  }

  private func showFullPage(message: String) {
    DispatchQueue.main.async {
      let messageLabel = UILabel()
      messageLabel.text = message
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      messageLabel.font = .preferredFont(forTextStyle: .body)
      messageLabel.sizeToFit()
      messageLabel.adjustsFontForContentSizeCategory = true

      self.tableView.backgroundView = messageLabel
      self.tableView.separatorStyle = .none
      self.tableView.reloadData()
    }
  }

  private func getUsersFailure(_ error: AppError) {
    showFullPage(message: error.message)
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

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
      dataSource.isFetching = true
      tableView.reloadData()
      viewModel.getNewUsers()
    }
  }

}
