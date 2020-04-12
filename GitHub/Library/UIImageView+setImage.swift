import UIKit
import Kingfisher

extension UIImageView {

  func setImage(url: URL) {
    kf.indicatorType = .activity
    kf.setImage(with: url)
  }
}
