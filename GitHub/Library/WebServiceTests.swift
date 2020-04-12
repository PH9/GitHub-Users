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

    var responseData: Data?
    var responseError: Error?

    init(spy: SpyURLSessionDataTask) {
      self.spy = spy
    }

    override func dataTask(
      with url: URL,
      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
      completionHandler(responseData, nil, responseError)
      return spy
    }
  }

  func test_shouldCallResumeOnce_andMustGotErrorEvenDataAlsoCome() {
    let webService = WebService()
    let spyDataTask = SpyURLSessionDataTask()
    let spySession = SpySession(spy: spyDataTask)
    spySession.responseError = NSError(domain: "", code: -1, userInfo: nil)
    webService.session = spySession
    let dummyRequest = DummyRequest()

    let callbackExpectation = expectation(description: "should callback")
    webService.request(request: dummyRequest) { result in
      switch result {
      case .success:
        assertionFailure("should not got success result")
      case .failure:
        break
      }

      callbackExpectation.fulfill()
    }

    wait(for: [callbackExpectation], timeout: 1)

    XCTAssertEqual(1, spyDataTask.resumeCalledCount)
  }
}
