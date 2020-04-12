import Foundation
@testable import GitHub

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

    if let error = error {
      completion(.failure(error))
    }

    if let responseData = responseData as? R.ResponseType {
      completion(.success(responseData))
    }
  }
}
