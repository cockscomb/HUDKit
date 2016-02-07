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

public class HUDPresentationController: UIPresentationController {

    /// Color of dimming
    public var dimmingColor = UIColor(white: 0.0, alpha: 0.4)
    // TODO: Use positive values
    /// Content insets
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    /// Corner radius
    public var cornerRadius: CGFloat = 8.0
    /// Visual effect of HUD background
    public var HUDVisualEffect: UIVisualEffect = UIBlurEffect(style: .ExtraLight)
    /// Dismiss when dimming tapped
    public var dismissWhenTapped: Bool = false

    private lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
        view.backgroundColor = self.dimmingColor
        view.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismiss:")
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()

    private lazy var HUDView: UIView = {
        let visualEffectView = UIVisualEffectView(effect: self.HUDVisualEffect)
        visualEffectView.frame = self.frameOfPresentedViewInContainerView()
        visualEffectView.layer.cornerRadius = self.cornerRadius
        visualEffectView.layer.masksToBounds = self.cornerRadius != 0.0

        let contentView = self.presentedViewController.view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.contentView.addSubview(contentView)

        let contentSize = self.presentedViewController.preferredContentSize

        let constraints: [NSLayoutConstraint] =
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[contentView]-right-|", options: [], metrics: [ "left" : self.contentInsets.left , "right" : self.contentInsets.right ], views: [ "contentView" : contentView ]) +
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[contentView]-bottom-|", options: [], metrics: [ "top" : self.contentInsets.top , "bottom" : self.contentInsets.bottom ], views: [ "contentView" : contentView ]) +
            [
                NSLayoutConstraint(item: visualEffectView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: visualEffectView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
            ]
        NSLayoutConstraint.activateConstraints(constraints)

        return visualEffectView
    }()

    func dismiss(sender: AnyObject?) {
        if dismissWhenTapped {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: - Override

    public override func presentedView() -> UIView? {
        return HUDView
    }

    public override func presentationTransitionWillBegin() {
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        containerView?.insertSubview(dimmingView, atIndex: 0)

        let constraints: [NSLayoutConstraint] =
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: [], metrics: nil, views: [ "view" : dimmingView ]) +
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: [], metrics: nil, views: [ "view" : dimmingView ])
        NSLayoutConstraint.activateConstraints(constraints)

        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ context in
            self.dimmingView.alpha = 1.0
            self.presentingViewController.view.tintAdjustmentMode = .Dimmed
        }, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ context in
            self.dimmingView.alpha = 0.0
            self.presentingViewController.view.tintAdjustmentMode = .Automatic
        }, completion: nil)
    }

    public override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    public override func frameOfPresentedViewInContainerView() -> CGRect {
        let containerRect = containerView?.bounds ?? CGRect.zero
        var rect = containerRect
        rect.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerView?.bounds.size ?? CGSize.zero)
        rect.origin.x = (containerRect.width - rect.width) / 2.0
        rect.origin.y = (containerRect.height - rect.height) / 2.0
        return UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(-contentInsets.top, -contentInsets.left, -contentInsets.bottom, -contentInsets.right))
    }

    public override func shouldPresentInFullscreen() -> Bool {
        return true
    }

    // MARK: UIContentContainer

    public override func containerViewWillLayoutSubviews() {
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }

    public override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let preferredSize = presentedViewController.preferredContentSize
        let bounds = CGRectInset(containerView?.bounds ?? CGRect.zero, contentInsets.left + contentInsets.right, contentInsets.top + contentInsets.bottom)
        return CGRectIntersection(bounds, CGRect(origin: CGPointZero, size: preferredSize)).size
    }

    public override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        if container === presentedViewController && containerView != nil {
            presentedView()?.frame = frameOfPresentedViewInContainerView()
        }
    }
    
}
