import UIKit

class GitHubUserViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    getUsers { result in
      switch result {
      case .success(let user):
        print(user)
      case .failure(let error):
        print(error)
      }
    }
  }

  private func getUsers(completionHandler completion: @escaping (Result<User, Error>) -> Void) {

  }
}

