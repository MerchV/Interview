//
//  StopTimesAnimator.swift
//  Transit
//
//  Created by Merch on 2016-08-01.
//  Copyright © 2016 MerchV. All rights reserved.
//

import UIKit

@objc class StopTimesAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    /*
     Push:

     from initial: yes
     from final: no

     to initial: no
     to final: yes


     Pop:

     from initial: yes
     from final: no

     to initial: no
     to final: yes
     
     */

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)
        }

        let fromViewInitialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!)
        let fromViewFinalFrame = presenting == true ? fromViewInitialFrame : fromViewInitialFrame.offsetBy(dx: fromViewInitialFrame.size.width, dy: 0)

        let toViewFinalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        let toViewInitialFrame = presenting == true ?  toViewFinalFrame.offsetBy(dx: toViewFinalFrame.size.width, dy: 0) : toViewFinalFrame
        
        transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewInitialFrame

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: { () -> Void in
            transitionContext.view(forKey: UITransitionContextViewKey.from)?.frame = fromViewFinalFrame
            transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewFinalFrame
        }) { (done) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }


    }
}
