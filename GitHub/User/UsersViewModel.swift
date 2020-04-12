import Foundation

class UsersViewModel {

  private var users: [User] = []

  var getUsersSuccess: (([User]) -> Void)?
  var getUsersFailure: ((String) -> Void)?

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
        self.getUsersSuccess?(self.users)
      case .failure(let error):
        self.getUsersFailure?(error.message)
      }
    }

  }

  func getNewUsers() {
    getUsers(sinceId: users.last?.id ?? 0)
  }

}
