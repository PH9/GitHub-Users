import Foundation

protocol Requestable {

  associatedtype ResponseType: Decodable

  var url: URL { get }
}

class WebService {

  static let shared = WebService()

  var session = URLSession.shared

  func request<R: Requestable>(
    request: R,
    completionHandler completion: @escaping (Result<R.ResponseType, AppError>) -> Void) {
    let urlRequest = createURLRequest(request: request)
    let task = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        let appError = AppError(error: error)
        completion(.failure(appError))
        return
      }

      guard let data = data else {
        let appError = AppError(message: "Unexpected response, please try again later")
        completion(.failure(appError))
        return
      }

      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        if let error = try? JSONDecoder().decode(AppError.self, from: data) {
          completion(.failure(error))
          return
        }

        let appError = AppError(message: "")
        completion(.failure(appError))
        return
      }

      do {
        let decoded = try JSONDecoder().decode(R.ResponseType.self, from: data)
        completion(.success(decoded))
      } catch {
        let appError = AppError(error: error)
        completion(.failure(appError))
        return
      }

    }

    task.resume()
  }

  private func createURLRequest<R: Requestable>(request: R) -> URLRequest {
    let urlRequest = URLRequest(url: request.url)
    return urlRequest
  }
}
