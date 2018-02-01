//
//  AlertAnimator.swift
//  Trainer
//
//  Created by Merch on 2017-09-29.
//  Copyright © 2017 Fitness Republic. All rights reserved.
//

import UIKit

class AlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false
    var duration = 0.2

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if presenting {
            transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)
            transitionContext.containerView.alpha = 0.0
            transitionContext.view(forKey: UITransitionContextViewKey.to)!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                transitionContext.containerView.alpha = 1.0
                transitionContext.view(forKey: UITransitionContextViewKey.to)!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (done) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            transitionContext.containerView.alpha = 1.0
            UIView.animate(withDuration: duration, animations: { () -> Void in
                transitionContext.containerView.alpha = 0.0
            }) { (done) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

}

///////////////////////////////////////////////////////////////////////////////

class AlertPresentationController: UIPresentationController {

    lazy var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            let presentedSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
            let rect = CGRect(x: containerView!.bounds.size.width - presentedSize.width, y: 0, width: presentedSize.width, height: presentedSize.height)
            let insetRect = rect.insetBy(dx: 20, dy: 80)
            return rect//insetRect
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        dimmingView.frame = containerView!.bounds
        containerView?.insertSubview(dimmingView, at: 0)
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return parentSize
    }

    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
    }

}
