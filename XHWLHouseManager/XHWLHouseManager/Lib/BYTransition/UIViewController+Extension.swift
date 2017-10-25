//
//  UIViewController+Extension.swift
//  BYTransition
//
//  Created by gongairong on 2017/10/8.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

//MARK: 实现push/pop的动画 UIViewController_Extension
extension UIViewController: UINavigationControllerDelegate , UIViewControllerTransitioningDelegate { //
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print("\(navigationController) \(operation.rawValue)")
        
//        if operation==UINavigationControllerOperation.push {
//            return BYPushAnimation_02()
//        }
//        else if operation==UINavigationControllerOperation.pop{
//            return BYPopAnimation_02()
//          
//        }
        return nil
    }
    
    
    // present
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pushAnimation:BYPushAnimation_07 = BYPushAnimation_07()
        pushAnimation.isPresent = true
        pushAnimation.currentFrame = presented.view?.frame
        return pushAnimation
    }
    
    // dismiss
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pushAnimation:BYPushAnimation_07 = BYPushAnimation_07()
        pushAnimation.isPresent = false
        pushAnimation.currentFrame = dismissed.view?.frame
        return pushAnimation
    }
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

/**
 *屏幕快照
 */
extension UIViewController {
    // MARK: - BYAnimationTransitioningSnapshot
    
//    public static func awake() {
    public class func initializeOnceMethod() {
        struct Static {
            static var token = NSUUID().uuidString
            //            static var token: dispatch_once_t = 0
        }
        
        // 确保不是子类
        if self != UIViewController.self {
            return
        }
        
        DispatchQueue.once(token: Static.token) {
            
            let originalSelector = #selector(UIViewController.viewDidLoad)
            let swizzledSelector = #selector(UIViewController.by_viewDidLoad)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }

    @objc func by_viewDidLoad() {
        if ((self.navigationController != nil) && self != self.navigationController?.viewControllers.first) {
            let popRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePopRecognizer(_:)))
            self.view.addGestureRecognizer(popRecognizer)
        }

        self.by_viewDidLoad()
    }

    @objc func handlePopRecognizer(_ recognizer:UIPanGestureRecognizer) {
        var w_isDragging:Bool = false
        var progress:CGFloat = recognizer.translation(in: self.view).x / self.view.frame.width
        progress = min(1.0, max(0.0, progress))
        if (progress <= 0 && !w_isDragging && recognizer.state != .began) {
            return;
        }
        if (recognizer.state == .began)
        {
            w_isDragging = true
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
           self.navigationController?.popViewController(animated: true)
        }
        else if (recognizer.state == .changed)
        {
            w_isDragging = true
            self.interactivePopTransition?.update(progress)
        }
        else if (recognizer.state == .ended || recognizer.state == .cancelled)
        {
            if (progress > 0.25)
            {
                w_isDragging = false
                self.interactivePopTransition?.finish()
            }
            else
            {
                w_isDragging = false
                self.interactivePopTransition?.cancel()
            }
            self.interactivePopTransition = nil
        }
    }

    var interactivePopTransition: UIPercentDrivenInteractiveTransition? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYInteractivePopTransition".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYInteractivePopTransition".hashValue)
            let obj: UIPercentDrivenInteractiveTransition? = objc_getAssociatedObject(self, key) as? UIPercentDrivenInteractiveTransition
            if (!(obj != nil))
            {
                self.interactivePopTransition = obj
            }
            return obj
        }
    }
    
    var snapshot: UIView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningSnapshot".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningSnapshot".hashValue)
            var view: UIView? = objc_getAssociatedObject(self, key) as? UIView
            if (!(view != nil))
            {
                if (self.tabBarController != nil) {
                    view =  self.tabBarController?.view.snapshotView(afterScreenUpdates: false)
                } else {
                    view = self.navigationController?.view.snapshotView(afterScreenUpdates: false)
                }
            
                self.snapshot = view
            }
            return view;
        }
    }
    

    
    var topSnapshot: UIView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningTopSnapshot".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningTopSnapshot".hashValue)
            var view: UIView? = objc_getAssociatedObject(self, key) as? UIView
            if(!(view != nil))
            {
                view = self.navigationController?.view.resizableSnapshotView(from: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:64), afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
                self.topSnapshot = view
            }
            return view;
        }
    }
    
    var viewSnapshot: UIView? {
        set {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningViewSnapshot".hashValue)
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let key: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "BYAnimationTransitioningViewSnapshot".hashValue)
            var view: UIView? = objc_getAssociatedObject(self, key) as? UIView
            if (!(view != nil)) {
                view = self.navigationController?.view.resizableSnapshotView(from: CGRect(x:0, y:64, width:UIScreen.main.bounds.width, height:(UIScreen.main.bounds.height - 64)), afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
                
                self.viewSnapshot = view
            }
            return view
        }
    }
    
    ///获取截图
    func imageFromView(_ snapView:UIView) -> UIImage {
        
        UIGraphicsBeginImageContext(snapView.frame.size)
        let context = UIGraphicsGetCurrentContext() // CGContextRef
        snapView.layer.render(in: context!)
        let targetImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return targetImage
    }
}
