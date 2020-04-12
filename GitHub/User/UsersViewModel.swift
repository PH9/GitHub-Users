class UsersViewModel {

  var getUserSuccess: (([User]) -> Void)?
  var getUserFailure: ((AppError) -> Void)?

  func getUsers() {

  }
}
