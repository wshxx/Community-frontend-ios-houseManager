//
//  BYPushAnimation_07.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

let WIDTH = UIScreen.main.bounds.size.width;
let HEIGHT = UIScreen.main.bounds.size.height;

class BYPushAnimation_07: NSObject , UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval? = 0.5
    var currentFrame : CGRect?;
    var fromView : UIView?
    var toView : UIView?
    var containerView : UIView?
    var isPresent : Bool?;
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration!
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        containerView = transitionContext.containerView;
        fromView = transitionContext.view(forKey: .from);
        toView = transitionContext.view(forKey: .to);
        containerView?.addSubview(toView!);
        self.animte(transitionContext: transitionContext);
    }

    func animte(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent! {
            toView?.frame = CGRect.init(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT);
            UIView.animate(withDuration: 0.2, animations: {
                self.fromView?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95);
            }, completion: { (Bool) in
                UIView.animate(withDuration: self.duration!, animations: {
                    self.toView?.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT);
                }, completion: { (Bool) in
                    self.fromView?.transform = CGAffineTransform.identity;
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
                });
            })
        }else{
            containerView?.addSubview(fromView!);
            toView?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95);
            fromView?.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT);
            UIView.animate(withDuration: duration!, animations: {
                self.fromView?.frame = CGRect.init(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT);
            }, completion: { (Bool) in
                UIView.animate(withDuration: self.duration!, animations: {
                    self.toView?.transform = CGAffineTransform.identity;
                }, completion: { (Bool) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
                });
            });
        }
        
    }
}
