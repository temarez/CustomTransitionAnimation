//
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

public enum SlideEdge : String {
    case top = "Top"
    case left = "Left"
    case bottom = "Bottom"
    case right = "Right"
    case topRight = "Top-Right"
    case topLeft = "Top-Left"
    case bottomRight = "Bottom-Right"
    case bottomLeft = "Bottom-Left"
}

class SlideTransitionAnimator: BaseTransitionAnimator {
    public var edge: SlideEdge = SlideEdge.topLeft
    
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
            UIView.animate(withDuration: duration, animations: {
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
            UIView.animate(withDuration: duration, animations: {
                fromView.frame = offscreenRect
            }) { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    public func rectOffset(from rect: CGRect, at edge: SlideEdge) -> CGRect {
        var offsetRect: CGRect = rect
        switch edge {
        case .top:
            offsetRect.origin.y -= rect.height
        case .left:
            offsetRect.origin.x -= rect.width
        case .bottom:
            offsetRect.origin.y += rect.height
        case .right:
            offsetRect.origin.x += rect.width
        case .topRight:
            offsetRect.origin.y -= rect.height
            offsetRect.origin.x += rect.width
        case .topLeft:
            offsetRect.origin.y -= rect.height
            offsetRect.origin.x -= rect.width
        case .bottomRight:
            offsetRect.origin.y += rect.height
            offsetRect.origin.x += rect.width
        case .bottomLeft:
            offsetRect.origin.y += rect.height
            offsetRect.origin.x -= rect.width
        }
        
        return offsetRect
    }
    
}
