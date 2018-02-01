//
//  EditProfileCrossDissolveAnimator.swift
//  Fitness Republic
//
//  Created by Merch on 2017-01-19.
//  Copyright © 2017 Fitness Republic. All rights reserved.
//

import UIKit

class EditProfileCrossDissolveAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false
    var duration = 0.5


    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let container = transitionContext.containerView

        if presenting == true {
            container.addSubview(toView!)
            toView?.translatesAutoresizingMaskIntoConstraints = false
            let leftConstraint = NSLayoutConstraint(item: toView, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let rightConstraint = NSLayoutConstraint(item: toView, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let topConstraint = NSLayoutConstraint(item: toView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint(item: toView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            container.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])

//            var viewProfileScrollViewController: ViewProfileScrollViewController?
//            if fromVC is ProfileContainerViewController { // changes based on context settings
//                let profileContainerViewController = fromVC as! ProfileContainerViewController
//                let children = profileContainerViewController.childViewControllers
//                let firstChildVC = children.first
//                viewProfileScrollViewController = firstChildVC as! ViewProfileScrollViewController
//            } else if fromVC is ViewProfileScrollViewController {
//                viewProfileScrollViewController = fromVC as! ViewProfileScrollViewController
//            }

            transitionContext.containerView.alpha = 0.0


            UIView.animate(withDuration: duration, animations: { () -> Void in
                transitionContext.containerView.alpha = 1.0
                viewProfileScrollViewController?.view.alpha = 0.0
            }) { (done) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }



        } else if presenting == false {
//            var viewProfileScrollViewController: ViewProfileScrollViewController?
//            if toVC is ProfileContainerViewController { // changes based on context settings
//                let profileContainerViewController = toVC as! ProfileContainerViewController
//                let children = profileContainerViewController.childViewControllers
//                let firstChildVC = children.first
//                viewProfileScrollViewController = firstChildVC as! ViewProfileScrollViewController
//            } else if toVC is ViewProfileScrollViewController {
//                viewProfileScrollViewController = toVC as! ViewProfileScrollViewController
//            }
            UIView.animate(withDuration: duration, animations: { () -> Void in
                transitionContext.containerView.alpha = 0.0
//                viewProfileScrollViewController?.view.alpha = 1.0
            }) { (done) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

    }
}
