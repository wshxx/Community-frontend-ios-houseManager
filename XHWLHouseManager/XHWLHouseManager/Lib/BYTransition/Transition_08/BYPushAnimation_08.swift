//
//  BYPushAnimation_08.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class BYPushAnimation_08: NSObject, UIViewControllerAnimatedTransitioning , CAAnimationDelegate {
    
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
        let start = CGPoint.init(x: (currentFrame?.origin.x)! + (currentFrame?.size.width)! / 2, y: (currentFrame?.origin.y)! + (currentFrame?.size.height)! / 2);
        let maxRadius = sqrt(pow(HEIGHT, 2) + pow(WIDTH, 2));
        let minRadius = 1;
        
        let startCycle : UIBezierPath?;
        let endCycle : UIBezierPath?;
        if isPresent! {
            startCycle = UIBezierPath.init(arcCenter: start, radius: CGFloat(minRadius), startAngle: 0, endAngle: CGFloat(M_PI + M_PI), clockwise: true);
            endCycle = UIBezierPath.init(arcCenter: start, radius: maxRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true);
        }else{
            startCycle = UIBezierPath.init(arcCenter: start, radius: maxRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true);
            endCycle = UIBezierPath.init(arcCenter: start, radius: CGFloat(minRadius), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true);
        }
        let masklayer = CAShapeLayer.init();
        masklayer.path = endCycle?.cgPath;
        if isPresent! {
            toView?.layer.mask = masklayer;
        }else{
            containerView?.addSubview(fromView!);
            fromView?.layer.mask = masklayer;
        }
        let maskbasic = CABasicAnimation.init(keyPath: "path");
        maskbasic.fromValue = startCycle?.cgPath;
        maskbasic.toValue = endCycle?.cgPath;
        maskbasic.duration = duration!;
        maskbasic.delegate = self;
        maskbasic.setValue(transitionContext, forKey: "trans");
        masklayer.add(maskbasic, forKey: "");
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let trans = anim.value(forKey: "trans") as! UIViewControllerContextTransitioning;
        trans.completeTransition(!trans.transitionWasCancelled);
    }
}
