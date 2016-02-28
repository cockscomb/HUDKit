# HUDKit

HUDKit provides HUD interface as `UIPresentationController`.

## Features

HUDKit provides `HUDPresentationController`. This is the HUD interface as an implementation of `UIPresentationController`. You can show your any view controllers in the HUD panel.

HUDKit provides `HUDProgressViewController` also. This can be used as progress HUD easily.

## Usage

Your view controller must implements `UIViewControllerTransitioningDelegate` like below.

```swift
import UIKit
import HUDKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    ...

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let HUD = HUDPresentationController(presentedViewController: presented, presentingViewController: presenting)
        HUD.dismissWhenTapped = true
        return HUD
    }

}
```

Next, you have to set it to the `transitioningDelegate` property and set `.Custom` to `modalPresentationStyle` property of your presented view controller.

Now, call `presentViewController(_:animated:completion:)`.

You can read the sample code at _Example_ directory for further informations.

## Requirements

- iOS 8 or later

## Author

Hiroki Kato, mail@cockscomb.info

## License

HUDKit is available under the MIT license. See the LICENSE file for more info.
