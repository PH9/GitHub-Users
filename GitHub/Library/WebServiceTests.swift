import XCTest
@testable import GitHub

class WebServiceTests: XCTestCase {

  let webService = WebService()
  let spyDataTask = SpyURLSessionDataTask()
  let dummyRequest = DummyRequest()
  var spySession: SpySession!

  override func setUp() {
    super.setUp()
    spySession = SpySession(spy: spyDataTask)
    webService.session = spySession
  }

  func test_shouldCallResumeOnce_andMustGotErrorEvenDataAlsoCome() {
    spySession.responseData = "{ \"isBool\": false }".data(using: .utf8)!
    spySession.responseError = NSError(domain: "", code: -2, userInfo: nil)

    let callbackExpectation = expectation(description: "should callback")
    webService.request(request: dummyRequest) { result in
      switch result {
      case .success(let response):
        assertionFailure("should not got success result, but got \(response)")
      case .failure(let error):
        XCTAssertEqual(-2, error.code)
      }

      callbackExpectation.fulfill()
    }

    wait(for: [callbackExpectation], timeout: 1)

    XCTAssertEqual(1, spyDataTask.resumeCalledCount)
    XCTAssertEqual("https://github.com/ph9/cv", spySession.url?.absoluteString)
  }

  func test_shouldAbleToParsingData() {
    spySession.responseData = "{ \"isBool\": false }".data(using: .utf8)!
    spySession.urlResponse = SuccessHTTPURLResponse(url: dummyRequest.url)

    let callbackExpectation = expectation(description: "should callback")
    webService.request(request: dummyRequest) { result in
      switch result {
      case .success(let response):
        XCTAssertEqual(false, response.isBool)
      case .failure(let error):
        assertionFailure("should not got failure result, but got error: \(error)")
      }

      callbackExpectation.fulfill()
    }

    wait(for: [callbackExpectation], timeout: 1)
  }

  func test_cannotParsingData() {
    spySession.responseData = "{}".data(using: .utf8)!
    spySession.urlResponse = SuccessHTTPURLResponse(url: dummyRequest.url)

    let callbackExpectation = expectation(description: "should callback")
    webService.request(request: dummyRequest) { result in
      switch result {
      case .success(let response):
        assertionFailure("should not got failure success, but got error: \(response)")
      case .failure(let error):
        XCTAssertEqual("The data couldn’t be read because it is missing.", error.message)
      }

      callbackExpectation.fulfill()
    }

    wait(for: [callbackExpectation], timeout: 1)
  }
}
