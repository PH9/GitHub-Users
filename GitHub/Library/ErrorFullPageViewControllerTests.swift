import XCTest
@testable import GitHub

class ErrorFullPageViewControllerTests: TestCase {

  func testView() {
    let message = """
    This is should be very long error message. So you can see it show in multiple lines as it need.
    Thanks for using ErrorFullPageViewController.
    Don't forgot to implement delegate so you user can tap to send retry Signal.
    """
    let vc = ErrorFullPageViewController.instantiate(message: message)

    let (parent, _) = traitControllers(child: vc)

    FBSnapshotVerifyView(parent.view)
  }
}
