//  The MIT License (MIT)
//
//  Copyright (c) 2016 Hiroki Kato
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public class HUDProgressViewController: UIViewController {

    @IBOutlet weak var customViewContainer: UIView! {
        didSet {
            if let view = customView {
                customViewContainer.addSubview(view)
                setUp(view)
            }
        }
    }
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.text = status
        }
    }

    public var customView: UIView? {
        willSet {
            if let view = customView {
                view.removeFromSuperview()
            }
        }
        didSet {
            if let view = customView {
                customViewContainer.addSubview(view)
                setUp(view)
            }
        }
    }

    public var activityIndicator: UIActivityIndicatorView? {
        return customView as? UIActivityIndicatorView
    }

    public var imageView: UIImageView? {
        return customView as? UIImageView
    }


    public var status: String? {
        didSet {
            statusLabel.text = status
        }
    }

    public var visualEffect: UIBlurEffectStyle?

    // MARK: - Initializer

    public init(customView: UIView?, status: String?, visualEffect: UIBlurEffectStyle = .Dark) {
        super.init(nibName: "HUDProgressViewController", bundle: NSBundle(forClass: HUDProgressViewController.self))

        self.customView = customView
        self.status = status
        self.visualEffect = visualEffect

        if let customView = customView {
            let insets = UIEdgeInsets(top: -30, left: -30, bottom: -30, right: -30)
            preferredContentSize = UIEdgeInsetsInsetRect(customView.bounds, insets).size
        } else {
            preferredContentSize = CGSizeMake(100.0, 100.0)
        }

        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }

    public convenience init(status: String?) {
        self.init(customView: UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge), status: status)
        activityIndicator?.startAnimating()
    }

    public convenience init(image: UIImage, status: String?) {
        self.init(customView: UIImageView(image: image), status: status)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    private func setUp(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: customViewContainer, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: customViewContainer, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
        ]
        NSLayoutConstraint.activateConstraints(constraints)
    }

}

extension HUDProgressViewController: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let HUD = HUDPresentationController(presentedViewController: presented, presentingViewController: presenting)
        HUD.HUDVisualEffect = UIBlurEffect(style: self.visualEffect ?? .Dark)
        return HUD
    }

}
