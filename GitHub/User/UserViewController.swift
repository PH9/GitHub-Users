import UIKit

class UserViewController: UITableViewController {

  let viewModel = UsersViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    bidingViewModel()
    viewModel.getUsers()
  }

  private func bidingViewModel() {
    viewModel.getUserSuccess = getUsersSuccess(_:)
    viewModel.getUserFailure = getUsersFailure(_:)
  }

  private func getUsersSuccess(_ users: [User]) {
    print(users)
  }

  private func getUsersFailure(_ error: AppError) {
    print(error)
  }
}

