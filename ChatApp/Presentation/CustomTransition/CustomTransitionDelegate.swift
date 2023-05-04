//
//  CustomTransitionDelegate.swift
//  ChatApp
//
//  Created by Станислава on 04.05.2023.
//

import UIKit

class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator(isPresenting: false)
    }
}
