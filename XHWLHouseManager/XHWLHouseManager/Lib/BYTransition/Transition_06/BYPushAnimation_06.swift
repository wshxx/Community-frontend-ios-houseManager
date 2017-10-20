//
//  BYPushAnimation_06.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class BYPushAnimation_06: NSObject , UIViewControllerAnimatedTransitioning {
    
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
        let pictureView = isPresent! ? toView : fromView;
        containerView?.bringSubview(toFront: pictureView!);
        let scaleX = (currentFrame?.size.width)! / (pictureView?.frame.size.width)!;
        let scaleY = (currentFrame?.size.height)! / (pictureView?.frame.size.height)!;
        let currentCenter = CGPoint.init(x: (currentFrame?.size.width)! / 2 + (currentFrame?.origin.x)!, y: (currentFrame?.size.height)! / 2 + (currentFrame?.origin.y)!);
        let pictureCenter = CGPoint.init(x: (pictureView?.frame.size.width)! / 2 + (pictureView?.frame.origin.x)!, y: (pictureView?.frame.size.height)! / 2 + (pictureView?.frame.origin.y)!);
        
        var startTransform : CGAffineTransform?;
        var startCenter : CGPoint?;
        var endTransform : CGAffineTransform?;
        var endCenter : CGPoint?;
        
        if isPresent! {
            startTransform = CGAffineTransform.init(scaleX: scaleX, y: scaleY);
            startCenter = currentCenter;
            endTransform = CGAffineTransform.identity;
            endCenter = pictureCenter;
        }else{
            startTransform = CGAffineTransform.identity;
            startCenter = pictureCenter;
            endTransform = CGAffineTransform.init(scaleX: scaleX, y: scaleY);
            endCenter = currentCenter;
        }
        
        pictureView?.transform = startTransform!;
        pictureView?.center = startCenter!;
        UIView.animate(withDuration: duration!, animations: {
            pictureView?.transform = endTransform!;
            pictureView?.center = endCenter!;
        }) { (Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled);
        }
    }
}
