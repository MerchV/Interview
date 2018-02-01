//
//  FadingAnimator.swift
//  Fitness Republic
//
//  Created by Merch Visoiu on 2016-12-12.
//  Copyright © 2016 Fitness Republic. All rights reserved.
//

import UIKit

class FadingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false
    var duration = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if presenting {
            transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)

//            toView.translatesAutoresizingMaskIntoConstraints = false
//            let leftConstraint = NSLayoutConstraint(item: toView, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0.0)
//            let rightConstraint = NSLayoutConstraint(item: toView, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0.0)
//            let topConstraint = NSLayoutConstraint(item: toView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0.0)
//            let bottomConstraint = NSLayoutConstraint(item: toView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//            container.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        }

        transitionContext.containerView.alpha = presenting ? 0.0 : 1.0

        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            transitionContext.containerView.alpha = self.presenting ? 1.0 : 0.0
        }) { (done) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
