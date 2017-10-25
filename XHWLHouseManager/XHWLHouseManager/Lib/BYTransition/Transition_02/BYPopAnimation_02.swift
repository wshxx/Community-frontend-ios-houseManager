//
//  BYPopAnimation_02.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class BYPopAnimation_02: NSObject, UIViewControllerAnimatedTransitioning{
    
    var transitionContext:UIViewControllerContextTransitioning?
    var tabbarFlag:Bool?
    let BY_CANCEL_POP:String = "BY_CANCEL_POP_NOTIFICATION"
    let isShowShadow:Bool? = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        self.tabbarFlag                 = false
        
        let fromVC:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC: UIViewController     = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let duration:TimeInterval     = self.transitionDuration(using: transitionContext)
        
        let bounds:CGRect            = UIScreen.main.bounds
        
        if isShowShadow! {
            fromVC.snapshot?.layer.shadowColor = UIColor.gray.cgColor
            fromVC.snapshot?.layer.shadowOffset = CGSize(width:-3, height:0)
            fromVC.snapshot?.layer.shadowOpacity = 0.5
        }
        
        fromVC.view.isHidden              = true
        fromVC.navigationController?.navigationBar.isHidden = true
        fromVC.view.transform = CGAffineTransform.identity
        
        toVC.view.isHidden                = true
        toVC.snapshot?.transform         = CGAffineTransform(scaleX: 0.95, y: 0.95)
        toVC.snapshot?.alpha             = 0.7
        
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.addSubview(toVC.snapshot!)
        transitionContext.containerView.sendSubview(toBack: toVC.snapshot!)
        transitionContext.containerView.addSubview(fromVC.snapshot!)
        
        if ((toVC.tabBarController != nil) && toVC == toVC.navigationController?.viewControllers.first)
        {
//            toVC.tabBarController?.tabBar.isHidden = true
            self.tabbarFlag = true
        }
        
        if ((fromVC.interactivePopTransition) != nil)
        {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            
                            fromVC.view.transform = CGAffineTransform(translationX: bounds.width, y: 0.0)
                            fromVC.snapshot?.transform = CGAffineTransform(translationX: bounds.width, y: 0.0)
                            toVC.snapshot?.transform = CGAffineTransform.identity
                            toVC.snapshot?.alpha = 1
            }) { (finished) in
                
                toVC.navigationController?.navigationBar.isHidden = false
                toVC.view.isHidden = false
                fromVC.view.isHidden              = false
                fromVC.snapshot?.removeFromSuperview()
                toVC.snapshot?.removeFromSuperview()
                fromVC.snapshot = nil
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if (!transitionContext.transitionWasCancelled)
                {
                    toVC.snapshot = nil;
                    if (self.tabbarFlag)!
                    {
                        toVC.tabBarController?.tabBar.isHidden = false
                    }
                }
                else
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.BY_CANCEL_POP), object:nil)
                }
                
            }
            
        }
        else
        {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping:1.0,
                           initialSpringVelocity:0,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            
                            fromVC.view.transform = CGAffineTransform(translationX: bounds.width, y: 0.0)
                            fromVC.snapshot?.transform = CGAffineTransform(translationX: bounds.width, y: 0.0)
                            toVC.snapshot?.transform = CGAffineTransform.identity
            }) { (finished) in
                
                toVC.navigationController?.navigationBar.isHidden = false
                toVC.view.isHidden = false
                fromVC.view.isHidden              = false
                fromVC.snapshot?.removeFromSuperview()
                toVC.snapshot?.removeFromSuperview()
                fromVC.snapshot = nil;
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
                if (!transitionContext.transitionWasCancelled) {
                    toVC.snapshot = nil;
                    if (self.tabbarFlag)!
                    {
                        toVC.tabBarController?.tabBar.isHidden = false
                    }
                }
                else
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.BY_CANCEL_POP), object:nil)
                }
                
            }
        }
    }

}
