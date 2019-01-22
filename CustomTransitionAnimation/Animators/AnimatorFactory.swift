//
//  AnimatorFactory.swift
//  CustomTransitionAnimation
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

// MARK: - Abstract factory
enum AnimatorType: String, CaseIterable {
    case none = "Default"
    case fade = "Fade"
    case slide = "Slide"
    case bounce = "Bounce"
    
    init?(id : Int) {
        switch id {
        case 0: self = .none
        case 1: self = .fade
        case 2: self = .slide
        case 3: self = .bounce
        default: return nil
        }
    }
}

enum AnimatorHelper {
    static func factory(for type: AnimatorType) -> UIViewControllerAnimatedTransitioning? {
        switch type {
        case .none:
            return nil
        case .fade:
            return FadeTransitionAnimator()
        case .slide:
            return SlideTransitionAnimator()
        case .bounce:
            return BounceTransitionAnimator()
        }
    }
}

