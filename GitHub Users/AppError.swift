struct AppError: Error {

  let message: String

  init(message: String) {
    self.message = message
  }

  init(error: Error) {
    message = error.localizedDescription
  }
}
