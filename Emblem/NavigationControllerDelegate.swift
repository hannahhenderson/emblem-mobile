//
//  NavigationControllerDelegate.swift
//  Emblem
//
//  Created by Dane Jordan on 9/19/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerDelegate: NSObject {
    
    @IBOutlet weak var navigationController: UINavigationController!
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DissolveTransitionAnimator()
    }
    
}