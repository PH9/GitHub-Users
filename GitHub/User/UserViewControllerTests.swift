import XCTest
@testable import GitHub

class UserViewControllerTests: XCTestCase {

  class SpyViewModel: UsersViewModel {

    var latestSinceUserId = -1
    var getUsersCalledCount = 0

    override func getUsers(sinceId userId: Int) {
      latestSinceUserId = userId
      getUsersCalledCount += 1
    }
  }

  var vc: UserViewController!

  override func setUp() {
    super.setUp()
    let storybaord = UIStoryboard(name: "User", bundle: nil)
    vc = storybaord.instantiateViewController(identifier: "UserViewController") as? UserViewController
  }

  func test_whenVCStart_shouldAlreadyCallGetUsersSinceId0() {
    let spy = SpyViewModel()
    vc?.viewModel = spy

    _ = vc?.view

    XCTAssertEqual(0, spy.latestSinceUserId)
    XCTAssertEqual(1, spy.getUsersCalledCount)
  }

  func test_whenPrefetchingWasCall_shouldCallViewModelGetUsersSinceId() {
    let spy = SpyViewModel()
    vc?.viewModel = spy

    _ = vc?.view

    vc?.usersDataSource(wantToFetchNewUser: 888)

    XCTAssertEqual(888, spy.latestSinceUserId)
    XCTAssertEqual(2, spy.getUsersCalledCount)
  }
}
