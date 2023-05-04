//
//  CustomTransitionAnimator.swift
//  ChatApp
//
//  Created by Станислава on 04.05.2023.
//

import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(toVC.view)
            toVC.view.frame = containerView.bounds
            toVC.view.frame.origin.y = 60
            toVC.view.alpha = 0
            toVC.view.layer.cornerRadius = 15
            
            let transition = CATransition()
            transition.type = .fade
            transition.duration = transitionDuration(using: transitionContext)
            containerView.layer.add(transition, forKey: kCATransition)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext) * 1.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [.curveEaseInOut],
                           animations: {
                toVC.view.alpha = 1
            },
                           completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = transitionDuration(using: transitionContext)
            containerView.layer.add(transition, forKey: kCATransition)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           animations: {
                fromVC.view.alpha = 0
            },
                           completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
