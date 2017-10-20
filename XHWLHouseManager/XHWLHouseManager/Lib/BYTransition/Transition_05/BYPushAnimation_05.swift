//
//  BYPushAnimation_05.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class BYPushAnimation_05: NSObject , UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval? = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration!
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) // as! FirstViewController
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) // as! SecondViewController
        let container = transitionContext.containerView
        let fromView:UIView = transitionContext.view(forKey: .from)!
        let toView:UIView = transitionContext.view(forKey: .to)!
        container.addSubview((toView))
//        container.bringSubview(toFront: (fromVC?.view)!)
        
        fromView.alpha = 1.0
        toView.alpha = 0.0
        UIView.animate(withDuration: duration!, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }) { (Bool) in
            fromView.alpha = 1.0
            let isCancelled = transitionContext.transitionWasCancelled;
            transitionContext.completeTransition(!isCancelled)
        }
    }

}
