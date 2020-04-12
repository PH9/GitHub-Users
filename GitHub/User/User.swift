// swiftlint:disable identifier_name
struct User: Decodable {

  let id: Int
  let login: String
  let avatar_url: String
  let html_url: String
  let type: String
  let site_admin: Bool
}
// swiftlint:enable identifier_name
