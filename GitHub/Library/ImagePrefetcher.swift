import Foundation
import Kingfisher

protocol ImagePrefetable {

  func start()
}

class ImagePrefetcher {

  var prefetcher: ImagePrefetable

  init(urls: [URL]) {
    prefetcher = Kingfisher.ImagePrefetcher(urls: urls)
  }

  func start() {
    prefetcher.start()
  }

}

extension Kingfisher.ImagePrefetcher: ImagePrefetable {

}
