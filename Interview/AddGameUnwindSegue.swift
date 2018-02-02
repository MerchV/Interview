//
//  AddGameUnwindSegue.swift
//  Interview
//
//  Created by Merch on 2018-02-01.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class AddGameUnwindSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    override func perform() {
        source.transitioningDelegate = self
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .custom
        source.modalPresentationStyle = .custom
       // destination.dismiss(animated: true, completion: nil)
    }


    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return self
    }

    // Only gets called if the storyboard segue is Present Modally.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        print(#function)
        return nil
    }


    var duration = 1.0
    let presenting = false

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

