@testable import GitHub
import Foundation

struct DummyRequest: Requestable {

  typealias ResponseType = DummyStruct

  let url = URL(string: "https://github.com/ph9/cv")!
}

struct DummyStruct: Decodable {
  let isBool: Bool
}

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
  var urlResponse: HTTPURLResponse?
  var responseError: Error?

  init(spy: SpyURLSessionDataTask) {
    self.spy = spy
  }

  override func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    url = request.url
    completionHandler(responseData, urlResponse, responseError)
    return spy
  }

}

class SuccessHTTPURLResponse: HTTPURLResponse {

  init(url: URL) {
    super.init(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var statusCode: Int {
    return 200
  }
}
