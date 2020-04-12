import Foundation

struct AppError: Error, Decodable {

  let message: String

  init(message: String) {
    self.message = message
  }

  init(error: Error) {
    message = error.localizedDescription
  }
}
