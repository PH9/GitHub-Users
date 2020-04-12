import XCTest
@testable import GitHub

class ImagePrefetcherTests: XCTestCase {

  class SpyImagePrefetcher: ImagePrefetable {

    var startCalledCount = 0

    func start() {
      startCalledCount += 1
    }
  }

  func testShouldCallPrefetcherStartOnce() {
    let spy = SpyImagePrefetcher()
    let prefetecher = ImagePrefetcher(urls: [])
    prefetecher.prefetcher = spy

    prefetecher.start()

    XCTAssertEqual(1, spy.startCalledCount)
  }

}
