import Foundation

struct UsersRequest: Requestable {

  typealias ResponseType = [User]

  let url: URL

  init(sinceId userId: Int) {
    url = URL(string: "https://api.github.com/users?since=\(userId)")!
  }
}
