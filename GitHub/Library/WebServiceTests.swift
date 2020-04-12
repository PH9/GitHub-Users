import XCTest
@testable import GitHub

struct DummyRequest: Requestable {

  typealias ResponseType = DummyStruct

  let url = URL(string: "https://github.com/ph9/cv")!
}

struct DummyStruct: Decodable {
  let isBool: Bool
}

class WebServiceTests: XCTestCase {

  class SpyURLSessionDataTask: URLSessionDataTask {

    var resumeCalledCount = 0

    override init() {}

    override func resume() {
      resumeCalledCount += 1
    }
  }

  class SpySession: URLSession {

    private var spy: SpyURLSessionDataTask

    var url: URL?
    var responseData: Data?
    var responseError: Error?

    init(spy: SpyURLSessionDataTask) {
      self.spy = spy
    }

    override func dataTask(
      with url: URL,
      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
      self.url = url
      completionHandler(responseData, nil, responseError)
      return spy
    }
  }

  func test_shouldCallResumeOnce_andMustGotErrorEvenDataAlsoCome() {
    let webService = WebService()
    let spyDataTask = SpyURLSessionDataTask()
    let spySession = SpySession(spy: spyDataTask)
    spySession.responseError = NSError(domain: "", code: -2, userInfo: nil)
    spySession.responseData = "{ \"isBool\": false }".data(using: .utf8)!
    webService.session = spySession
    let dummyRequest = DummyRequest()

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
    let webService = WebService()
    let spyDataTask = SpyURLSessionDataTask()
    let spySession = SpySession(spy: spyDataTask)
    spySession.responseData = "{ \"isBool\": false }".data(using: .utf8)!
    webService.session = spySession
    let dummyRequest = DummyRequest()

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
    let webService = WebService()
    let spyDataTask = SpyURLSessionDataTask()
    let spySession = SpySession(spy: spyDataTask)
    spySession.responseData = "{}".data(using: .utf8)!
    webService.session = spySession
    let dummyRequest = DummyRequest()

    let callbackExpectation = expectation(description: "should callback")
    webService.request(request: dummyRequest) { result in
      switch result {
      case .success(let response):
        assertionFailure("should not got failure success, but got error: \(response)")
      case .failure(let error):
        XCTAssertEqual("Unexpected response, please try again later", error.message)
      }

      callbackExpectation.fulfill()
    }

    wait(for: [callbackExpectation], timeout: 1)
  }
}