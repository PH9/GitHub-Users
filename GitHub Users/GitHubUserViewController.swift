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

  private func getUsers(completionHandler completion: @escaping (Result<[User], AppError>) -> Void) {
    let session = URLSession.shared
    let url = URL(string: "https://api.github.com/users")!

    let task = session.dataTask(with: url) { data, response, error in
      if let error = error {
        let appError = AppError(error: error)
        completion(.failure(appError))
        return
      }
    }

    task.resume()
  }
}

