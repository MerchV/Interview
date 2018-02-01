//
//  StopTimesPresentationController.swift
//  Transit
//
//  Created by Merch on 2016-08-01.
//  Copyright © 2016 MerchV. All rights reserved.
//

import UIKit

@objc class StopTimesPresentationController: UIPresentationController {

  //  var touchForwardingView: TouchForwardingView

    lazy var dismissingView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissingViewTapped))
        view.addGestureRecognizer(tap)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissingViewTapped))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    //    touchForwardingView = TouchForwardingView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            let presentedSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
            let rect = CGRect(x: containerView!.bounds.size.width - presentedSize.width, y: 0, width: presentedSize.width, height: presentedSize.height)
            return rect
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
//        touchForwardingView.passthroughViews = [presentingViewController.view]
//        containerView?.insertSubview(touchForwardingView, at: 0)
        dismissingView.frame = containerView!.bounds
        containerView?.insertSubview(dismissingView, at: 0)
    }

//    override var shouldPresentInFullscreen: Bool

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: 320, height: parentSize.height)
    }

    override func containerViewWillLayoutSubviews() {
        dismissingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
    }

//    override func adaptivePresentationStyle(for traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return .overFullScreen
//    }

    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return nil
    }

    // MARK: - Actions

    func dismissingViewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .recognized {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }

}
