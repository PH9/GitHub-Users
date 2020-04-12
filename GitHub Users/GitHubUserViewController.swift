import UIKit

class GitHubUserViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    getUsers { result in
      switch result {
      case .success(let users):
        print(users)
      case .failure(let error):
        print(error)
      }
    }
  }

  private func getUsers(completionHandler completion: @escaping (Result<[User], Error>) -> Void) {

  }
}

