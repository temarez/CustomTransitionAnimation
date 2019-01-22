//
//  FadeTransitionAnimator.swift
//  CustomTransitionAnimation
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

class FadeTransitionAnimator: BaseTransitionAnimator {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view
            else { return }
        
        let containerView = transitionContext.containerView
        
        // Presenting
        if isAppearing {
            containerView.addSubview(toView)
            toView.alpha = 0.0
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.isAppearing {
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
    }
    
}

