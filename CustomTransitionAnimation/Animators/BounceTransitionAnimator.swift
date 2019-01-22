//
//  BounceTransitionAnimator.swift
//  CustomTransitionAnimation
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

class BounceTransitionAnimator: SlideTransitionAnimator {
    public var dampingRatio: CGFloat = 0.5
    public var velocity: CGFloat = 4.0
    
    // MARK: - UIViewControllerAnimatedTransitioning

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view
            else { return }
        
        let containerView: UIView = transitionContext.containerView
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        
        let initialFrame: CGRect = transitionContext.initialFrame(for: fromVC)
        let offscreenRect: CGRect = rectOffset(from: initialFrame, at: edge)
        
        // Presenting
        if isAppearing {
            // Position the view offscreen
            toView.frame = offscreenRect
            containerView.addSubview(toView)
            // Animate the view onscreen
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [], animations: {
                toView.frame = initialFrame
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        // Dismissing
        else {
            containerView.addSubview(toView)
            containerView.sendSubviewToBack(toView)
            // Animate the view offscreen
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: [], animations: {
                fromView.frame = offscreenRect
            }) { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

}
