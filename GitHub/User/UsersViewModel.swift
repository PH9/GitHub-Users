import Foundation

class UsersViewModel {

  private var users: [User] = []

  var getUserSuccess: (([User]) -> Void)?
  var getUserFailure: ((String) -> Void)?
  var showErrorCell: ((String) -> Void)?

  private var isFetching = false

  func getUsers(sinceId userId: Int = 0) {
    if isFetching {
      return
    }

    isFetching = true

    let userRequest = UsersRequest(sinceId: userId)
    WebService.shared.request(request: userRequest) { result in
      defer {
        self.isFetching = false
      }

      switch result {
      case .success(let users):
        self.users += users
        self.getUserSuccess?(self.users)
      case .failure(let error):
        if self.users.count > 0 {
          self.showErrorCell?(error.message)
          return
        }

        self.getUserFailure?(error.message)
      }
    }

  }

  func getNewUsers() {
    getUsers(sinceId: users.last?.id ?? 0)
  }

}
