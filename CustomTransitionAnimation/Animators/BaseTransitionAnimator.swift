//
//  BaseTransitionAnimator.swift
//  CustomTransitionAnimation
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

class BaseTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var isAppearing: Bool = false // isPresenting
    public var duration: TimeInterval = 1.0
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Must be implemented by inheriting class
        doesNotRecognizeSelector(#function)
    }
}
