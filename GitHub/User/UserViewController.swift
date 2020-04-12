import UIKit

class UserViewController: UITableViewController {

  private let spinner = UIActivityIndicatorView(style: .gray)

  var viewModel = UsersViewModel()
  let dataSource = UsersDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    binding()
    registerCell()
    viewModel.getUsers()
  }

  private func setupView() {
    spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 40)
    spinner.startAnimating()
    tableView.tableFooterView = spinner

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 172.5
  }

  private func binding() {
    tableView.dataSource = dataSource
    viewModel.getUsersSuccess = getUsersSuccess(_:)
    viewModel.getUsersFailure = getUsersFailure(_:)
  }

  private func registerCell() {
    tableView.register(FetchingCell.self)
  }

  private func getUsersSuccess(_ users: [User]) {
    if users.count == 0 {
      showFullPage(message: "GitHub have no user")
      return
    }
    dataSource.replace(users: users)
    tableView.reloadData()
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

  private func getUsersFailure(_ message: String) {
    spinner.stopAnimating()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let value = dataSource.values[indexPath.section][indexPath.row]

    guard let url = (value as? User)?.html_url else {
      return
    }

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

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
      spinner.stopAnimating()
      viewModel.getNewUsers()
    }
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
      spinner.startAnimating()
      viewModel.getNewUsers()
    }

  }

}
