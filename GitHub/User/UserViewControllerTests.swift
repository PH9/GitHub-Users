import XCTest
@testable import GitHub

class UserViewControllerTests: TestCase {

  class SpyViewModel: UsersViewModel {

    let expectation = XCTestExpectation(description: "called GetUserSuccess")
    var latestSinceUserId = -1
    var getUsersCalledCount = 0

    override func getUsers(sinceId userId: Int) {
      latestSinceUserId = userId
      getUsersCalledCount += 1
      getUsersSuccess?([
        User(
          id: 6365973,
          login: "PH9",
          avatar_url: "https://avatars2.githubusercontent.com/u/6365973?v=4",
          html_url: "https://github.com/PH9",
          type: "User",
          site_admin: false)
      ])

      expectation.fulfill()
    }
  }

  var vc: UserViewController!

  override func setUp() {
    super.setUp()
    let storybaord = UIStoryboard(name: "User", bundle: nil)
    vc = storybaord.instantiateViewController(identifier: "UserViewController") as? UserViewController
  }

  func testView() {
    let spy = SpyViewModel()
    vc.viewModel = spy
    _ = vc.view
    vc.viewModel.getUsers(sinceId: 0)

    wait(for: [spy.expectation], timeout: 1)

    let (regular, _) = traitControllers(child: vc)
    FBSnapshotVerifyView(regular.view)
  }

  func test_whenVCStart_shouldAlreadyCallGetUsersSinceId0() {
    let spy = SpyViewModel()
    vc?.viewModel = spy

    _ = vc.view

    XCTAssertEqual(0, spy.latestSinceUserId)
    XCTAssertEqual(1, spy.getUsersCalledCount)
  }

  func test_tableBingingShouldSetupCorrectly() {
    _ = vc.view

    let userDataSource = vc.tableView.dataSource as? UsersDataSource
    XCTAssertNotNil(userDataSource)
  }
}
