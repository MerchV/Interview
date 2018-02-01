//
//  SlideAnimator.swift
//
//  Created by Merch on 2016-08-07.
//  Copyright © 2016 MerchV. All rights reserved.
//

import UIKit

@objc class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = false

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)

        let fromViewInitialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!)
        let fromViewFinalFrame = presenting == true ? fromViewInitialFrame.offsetBy(dx: 0 - fromViewInitialFrame.size.width, dy: 0) : fromViewInitialFrame.offsetBy(dx: fromViewInitialFrame.size.width, dy: 0)

        let toViewFinalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        let toViewInitialFrame = presenting == true ?  toViewFinalFrame.offsetBy(dx: toViewFinalFrame.size.width, dy: 0) : toViewFinalFrame.offsetBy(dx: 0 - toViewFinalFrame.size.width, dy: 0)
        transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewInitialFrame

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            transitionContext.view(forKey: UITransitionContextViewKey.from)?.frame = fromViewFinalFrame
            transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewFinalFrame
        }) { (done) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }


    }

}
