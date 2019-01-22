//
//  ViewController.swift
//  CustomTransitionAnimation
//
//  Created by Artem Rieznikov on 1/22/19.
//  Copyright © 2019 Artem Rieznikov. All rights reserved.
//

import UIKit

// Segue Ids
private let kSegueDropDismiss = "dropDismiss"
private let kSegueOptionsDismiss = "optionsDismiss"
private let kSegueSlideModal = "slideModal"
private let kSegueSlidePush = "slidePush"

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var animationSegmentedControl: UISegmentedControl!
    
    var animationDuration: Float {
        return (durationSlider.value*10).rounded()/10
    }
    
    var pushTransitions: Bool = true
    var animatedTransitioning: UIViewControllerAnimatedTransitioning?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        tabBarController?.delegate = self
        
        animationSegmentedControl.removeAllSegments()
        for value in AnimatorType.allCases {
            animationSegmentedControl.insertSegment(withTitle: value.rawValue, at: animationSegmentedControl.numberOfSegments, animated: false)
        }
        animationSegmentedControl.selectedSegmentIndex = 0
        
    }
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        prepareTransitionAnimator()
    }
    
    @IBAction func animationSegmentedControlValueChanged(_ sender: AnyObject) {
        prepareTransitionAnimator()
    }
    
    private func prepareTransitionAnimator() {
        durationLabel.text = "Duration (sec): \(animationDuration)"

        let selectedTypeID = animationSegmentedControl.selectedSegmentIndex
        if let animatorType = AnimatorType(id: selectedTypeID) {
            animatedTransitioning = AnimatorHelper.factory(for: animatorType)
            if let transitionAnimator = animatedTransitioning as? BaseTransitionAnimator {
                transitionAnimator.duration = TimeInterval(animationDuration)
            }
        }
    }
    
    @IBAction func manualSegueButtonPress(_ sender: UIButton) {
        let identifier = pushTransitions ? kSegueSlidePush : kSegueSlideModal
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    /*
     Prepare for segue
     
     navigationController.delegate:
     We need to set the UINavigationControllerDelegate everytime for push transitions.
     This is necessary because this VC presents multiple VCs, some with custom transitions
     (Options, Slide, Bounce, Fold, Drop) and one with a standard transition (Flow 1).
     The delegate is set to self for the custom transitions so that they work with
     the navigation controller. The delegate is set to nil for the standard transition
     so that the default interactive pop transition works.
     
     modalPresentationStyle:
     Specify UIModalPresentationCustom for transitions where the source VC should
     stay in the view hierarchy after the transition is complete (Options, Drop).
     For the other cases (Slide, Bounce, Fold) we don't set it which defaults it
     to UIModalPresentationFullScreen.
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Slide - push
        if (segue.identifier == kSegueSlidePush) {
            navigationController?.delegate = self
            let toVC: UIViewController = segue.destination
            toVC.transitioningDelegate = self
        }
        // Slide - modal
        else if (segue.identifier == kSegueSlideModal) {
            let toVC: UIViewController = segue.destination
            toVC.transitioningDelegate = self
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    /* Called when presenting a view controller that has a transitioningDelegate */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionAnimator = animatedTransitioning as? BaseTransitionAnimator {
            transitionAnimator.isAppearing = true
        }
        
        return animatedTransitioning
    }
    
    /* Called when dismissing a view controller that has a transitioningDelegate */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionAnimator = animatedTransitioning as? BaseTransitionAnimator {
            transitionAnimator.isAppearing = false
        }
        
        return animatedTransitioning
    }
    
    // MARK: - UINavigationControllerDelegate
    
    /* Called when pushing/popping a view controller on a navigation controller that has a delegate */
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionAnimator = animatedTransitioning as? BaseTransitionAnimator {
            if operation == .push {
                transitionAnimator.isAppearing = true
            }
            else if operation == .pop {
                transitionAnimator.isAppearing = false
            }
        }
        
        return animatedTransitioning
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionAnimator = animatedTransitioning as? BaseTransitionAnimator {
            transitionAnimator.isAppearing = true
        }
        
        return animatedTransitioning
        
    }

    
    // MARK: - Storyboard unwinding
    
    /*
     Unwind segue action called to dismiss the Options and Drop view controllers and
     when the Slide, Bounce and Fold view controllers are dismissed with a single tap.
     
     Normally an unwind segue will pop/dismiss the view controller but this doesn't happen
     for custom modal transitions so we have to manually call dismiss.
     */
    @IBAction func unwind(toViewController sender: UIStoryboardSegue) {
        if (sender.identifier == kSegueOptionsDismiss) || (sender.identifier == kSegueDropDismiss) {
            dismiss(animated: true)
        }
    }
    
}

