import XCTest
@testable import GitHub

class UsersViewModelTests: XCTestCase {

  class MockWebService: WebService {

    let error: AppError?
    let responseData: Decodable?

    init(error: AppError) {
      self.error = error
      responseData = nil
    }

    init(responseData: Decodable? = nil) {
      error = nil
      self.responseData = responseData
    }

    override func request<R>(
      request: R,
      completionHandler completion: @escaping (Result<R.ResponseType, AppError>) -> Void
    ) where R: Requestable {
      if let responseData = responseData as? R.ResponseType {
        completion(.success(responseData))
      }
    }
  }

  func test_getUsersSuccess_shouldCallGetUsersSuccess() {
    let user = User(
      id: 6365973,
      login: "PH9",
      avatar_url: "https://avatars2.githubusercontent.com/u/6365973?v=4",
      html_url: "https://github.com/PH9",
      type: "User",
      site_admin: false)
    WebService.shared = MockWebService(responseData: [user])

    let viewModel = UsersViewModel()

    let getUsersSuccessExpectation = expectation(description: "should call")
    viewModel.getUsersSuccess = { users in
      XCTAssertEqual(1, users.count)

      XCTAssertEqual(user.id, users.last?.id)
      XCTAssertEqual(user.login, users.last?.login)
      XCTAssertEqual(user.avatar_url, users.last?.avatar_url)
      XCTAssertEqual(user.html_url, users.last?.html_url)
      XCTAssertEqual(user.type, users.last?.type)
      XCTAssertEqual(user.site_admin, users.last?.site_admin)
      getUsersSuccessExpectation.fulfill()
    }
    viewModel.getUsersFailure = { _ in
      assertionFailure("Should not call this even once")
    }

    viewModel.getUsers()

    wait(for: [getUsersSuccessExpectation], timeout: 1)
  }

  func test_getUserFail_shouldCallGetUsersFailure() {
    let error = AppError(message: "This is error message")
    WebService.shared = MockWebService(error: error)

    let viewModel = UsersViewModel()

    viewModel.getUsersSuccess = { _ in
      assertionFailure("Should not call this :)")
    }

    let getUsersFailureExpectation = expectation(description: "")
    viewModel.getUsersFailure = { errorMessage in
      XCTAssertEqual(error.message, errorMessage)
      getUsersFailureExpectation.fulfill()
    }

    viewModel.getUsers()

    wait(for: [getUsersFailureExpectation], timeout: 1)
  }

}
