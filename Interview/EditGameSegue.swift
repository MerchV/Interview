//
//  Created by Merch on 2017-09-30.
//

import UIKit

class EditGameSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    override func perform() {
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .custom // needed
        source.present(destination, animated: true, completion: nil)
    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        print(#function)
////        let presentationController = AlertPresentationController(presentedViewController: presented, presenting: presenting)
//        return nil// presentationController
//    }


    var presenting = true
    var duration = 1.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)

        let fromViewInitialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!)
        let fromViewFinalFrame = presenting == true ? fromViewInitialFrame.offsetBy(dx: 0 - fromViewInitialFrame.size.width, dy: 0) : fromViewInitialFrame.offsetBy(dx: fromViewInitialFrame.size.width, dy: 0)

        let toViewFinalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        let toViewInitialFrame = presenting == true ? toViewFinalFrame.offsetBy(dx: 0, dy: toViewFinalFrame.size.height) : toViewFinalFrame.offsetBy(dx: 0 - toViewFinalFrame.size.width, dy: 0)
        transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewInitialFrame





        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            transitionContext.view(forKey: UITransitionContextViewKey.from)?.frame = fromViewFinalFrame
            transitionContext.view(forKey: UITransitionContextViewKey.to)?.frame = toViewFinalFrame
        }) { (done:Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }

}
