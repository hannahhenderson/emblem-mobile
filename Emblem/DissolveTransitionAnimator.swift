//
//  DissolveTransitionAnimator.swift
//  Emblem
//
//  Created by Dane Jordan on 9/19/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import Foundation
import UIKit

class DissolveTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()
        //let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        
        
        containerView!.addSubview(toViewController!.view)
        
        toViewController!.view.alpha = 0.0
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {() -> Void in
            toViewController!.view.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
    
}