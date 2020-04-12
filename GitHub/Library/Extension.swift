import UIKit

extension UITableViewCell {

  static var reusableIdentifier: String {
    String(describing: self)
  }
}

extension UITableView {

  func dequeue<CellType: UITableViewCell>(_ cellType: CellType.Type, for indexPath: IndexPath) -> CellType {
    guard let cell = dequeueReusableCell(
      withIdentifier: cellType.reusableIdentifier,
      for: indexPath) as? CellType else {
        fatalError("Could not dequeue \(cellType.reusableIdentifier)")
    }

    return cell
  }
}
