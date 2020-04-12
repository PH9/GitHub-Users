import Foundation

class UsersViewModel {

  private var users: [User] = []

  var getUserSuccess: (([User]) -> Void)?
  var getUserFailure: ((AppError) -> Void)?

  private var isFetching = false

  func getUsers(sinceId userId: Int = 0) {
    isFetching = true

    let userRequest = UsersRequest(sinceId: userId)
    WebService.shared.request(request: userRequest) { result in
      defer {
        self.isFetching = false
      }

      switch result {
      case .success(let users):
        self.users += users
        self.getUserSuccess?(users)
      case .failure(let error):
        self.getUserFailure?(error)
      }
    }
  }

}
