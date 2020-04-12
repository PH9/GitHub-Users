import XCTest
@testable import GitHub

class UsersRequestTests: XCTestCase {

  func test_initilizeUsersRequest() {
    let request = UsersRequest(sinceId: -1)

    let expectedURL = URL(string: "https://api.github.com/users?since=-1")!
    XCTAssertEqual(expectedURL, request.url)
  }
}
