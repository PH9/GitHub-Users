struct AppError: Error {

  let message: String

  init(error: Error) {
    message = error.localizedDescription
  }
}
