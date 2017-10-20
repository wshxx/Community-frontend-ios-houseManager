//
//  BYPushAnimation_02.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class BYPushAnimation_02: NSObject ,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {
    
    var transitionContextT:UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContextT = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let duration:TimeInterval     = self.transitionDuration(using: transitionContext)
        let bounds:CGRect            = UIScreen.main.bounds
        
        fromVC?.view.isHidden          = true
        transitionContext.containerView.addSubview((toVC?.view)!)
        toVC?.navigationController?.view.superview?.insertSubview((fromVC?.snapshot)!, belowSubview: (toVC?.navigationController?.view)!)
        toVC?.navigationController?.view.transform = CGAffineTransform(translationX:bounds.width, y: 0)
        if ((fromVC?.tabBarController) != nil)
        {
            fromVC?.tabBarController?.tabBar.isHidden = true
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping:1.0,
                       initialSpringVelocity:0,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        fromVC?.snapshot?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        fromVC?.snapshot?.alpha = 0.7
                        toVC?.navigationController?.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finished) in
            fromVC?.view.isHidden = false
            fromVC?.snapshot?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }

}
