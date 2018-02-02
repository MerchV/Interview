//
//  AddGameSegue.swift
//  Interview
//
//  Created by Merch on 2018-02-01.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class AddGameSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    override func perform() {
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true, completion: nil)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }


    var presenting = true
    var duration = 1.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if presenting {
            transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)
            transitionContext.view(forKey: UITransitionContextViewKey.to)!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
                transitionContext.view(forKey: UITransitionContextViewKey.to)!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (done:Bool) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
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
