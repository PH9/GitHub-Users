import UIKit

private let iPhone4InchFrame = CGRect(x: 0, y: 0, width: 320, height: 568)

func traitControllers(
  child: UIViewController,
  additionalTraits: UITraitCollection = .init()
) -> (parent: UIViewController, child: UIViewController) {
  let parent = UIViewController()
  parent.view.addSubview(child.view)
  parent.addChild(child)
  parent.didMove(toParent: parent)

  parent.view.frame = iPhone4InchFrame
  let traits: UITraitCollection = .init(traitsFrom: [
    .init(horizontalSizeClass: .compact),
    .init(verticalSizeClass: .regular),
    .init(userInterfaceIdiom: .phone)
  ])

  child.view.frame = parent.view.frame

  parent.view.backgroundColor = .white
  child.view.backgroundColor = .white

  let allTraits = UITraitCollection.init(traitsFrom: [traits, additionalTraits])
  parent.setOverrideTraitCollection(allTraits, forChild: child)

  return (parent, child)
}
