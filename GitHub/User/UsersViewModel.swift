import Foundation

class UsersViewModel {

  var getUserSuccess: (([User]) -> Void)?
  var getUserFailure: ((AppError) -> Void)?

  func getUsers() {
    getUsers { result in
      switch result {
      case .success(let users):
        self.getUserSuccess?(users)
      case .failure(let error):
        self.getUserFailure?(error)
      }
    }
  }

  private func getUsers(completionHandler completion: @escaping (Result<[User], AppError>) -> Void) {
    let session = URLSession.shared
    let url = URL(string: "https://api.github.com/users")!

    let task = session.dataTask(with: url) { data, _, error in
      if let error = error {
        let appError = AppError(error: error)
        completion(.failure(appError))
        return
      }

      guard
        let data = data,
        let users = try? JSONDecoder().decode([User].self, from: data)
        else {
          let appError = AppError(message: "Unexpected response, please try again later")
          completion(.failure(appError))
          return
      }

      completion(.success(users))
    }

    task.resume()
  }
}
