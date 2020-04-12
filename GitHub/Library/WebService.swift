import Foundation

protocol Requestable {

  associatedtype ResponseType

  var url: URL { get }
}

class WebService {

  static var shared = WebService()

  func request<R: Requestable>(
    request: R,
    completionHandler completion: (Result<R.ResponseType, AppError>) -> Void) {
    
  }
}
