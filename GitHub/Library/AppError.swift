import Foundation

struct AppError: Error {

  let code: Int
  let message: String

  init(message: String) {
    code = -1
    self.message = message
  }

  init(error: Error) {
    code = (error as NSError).code
    message = error.localizedDescription
  }
}
