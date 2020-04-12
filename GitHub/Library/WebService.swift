import Foundation

protocol Requestable {

  associatedtype ResponseType: Decodable

  var url: URL { get }
}

class WebService {

  static var shared = WebService()

  func request<R: Requestable>(
    request: R,
    completionHandler completion: @escaping (Result<R.ResponseType, AppError>) -> Void) {
    let session = URLSession.shared

    let task = session.dataTask(with: request.url) { data, _, error in
      if let error = error {
        let appError = AppError(error: error)
        completion(.failure(appError))
        return
      }

      guard
        let data = data,
        let decoded = try? JSONDecoder().decode(R.ResponseType.self, from: data)
        else {
          let appError = AppError(message: "Unexpected response, please try again later")
          completion(.failure(appError))
          return
      }

      completion(.success(decoded))
    }

    task.resume()
  }
}
