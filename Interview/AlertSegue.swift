//
//  Created by Merch on 2017-09-30.
//

import UIKit

class BounceSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

    override func perform() {
//        super.perform()
        destination.transitioningDelegate = self
        destination.modalTransitionStyle = .coverVertical
        destination.modalPresentationStyle = .custom
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = AlertAnimator()
        animator.presenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = AlertAnimator()
        animator.presenting = false
        return animator
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        print(#function)
        let presentationController = AlertPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }


}
