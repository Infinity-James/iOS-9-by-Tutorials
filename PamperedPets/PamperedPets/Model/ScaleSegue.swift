//
//  ScaleSegue.swift
//  PamperedPets
//
//  Created by James Valaitis on 16/12/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
}

extension ScaleSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleDismissAnimator()
    }
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScalePresentAnimator()
    }
}

class ScalePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
                fatalError()
        }
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        let fromViewController: UIViewController
        if let navigationController = fromVC as? UINavigationController {
            fromViewController = navigationController.topViewController!
        } else {
            fromViewController = fromVC
        }
        
        transitionContext.containerView()?.addSubview(toView)
        
        var startFrame = CGRect.zero
        if let fromViewController = fromViewController as? ViewScalable {
            startFrame = fromViewController.scaleView.frame
        } else {
            print("Warning: Controller \(fromViewController) does not conform to ViewScalable.")
        }
        toView.frame = startFrame
        toView.layoutIfNeeded()
        
        let duration = transitionDuration(transitionContext)
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        UIView.animateWithDuration(duration, animations: {
            toView.frame = finalFrame
            toView.layoutIfNeeded()
            fromView?.alpha = 0.0
            }, completion:  { finished in
                fromView?.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
        
    }
}

class ScaleDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
                fatalError()
        }
        
        let toViewController: UIViewController
        if let navigationController = toVC as? UINavigationController {
            toViewController = navigationController.topViewController!
        } else {
            toViewController = toVC
        }
        
        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
            transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        }
        
        
        var endFrame = CGRect.zero
        if let toViewController = toViewController as? ViewScalable {
            endFrame = toViewController.scaleView.frame
        } else {
            print("Warning: Controller \(toViewController) does not conform to ViewScalable.")
        }
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            fromView.frame = endFrame
            fromView.layoutIfNeeded()
            }, completion:  { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
        
    }
}

protocol ViewScalable {
    var scaleView: UIView { get }
}