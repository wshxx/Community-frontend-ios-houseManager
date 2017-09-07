// Copyright (c) 2016 rickytan <ricky.tan.xin@gmail.com>
//

#import <UIKit/UIKit.h>

#import "UIViewController+RTRootNavigationController.h"


@interface RTContainerController : UIViewController
@property (nonatomic, readonly, strong) __kindof UIViewController *contentViewController; // __kindof
@end


/**
 *  如果你的项目使用 UITabBarController, 推荐将其放入到 RTRootNavigationController 下面，包含起来 例如：
 
tabController.viewControllers = @[[[RTContainerNavigationController alloc] initWithRootViewController:vc1],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc2],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc3],
                                  [[RTContainerNavigationController alloc] initWithRootViewController:vc4]];
self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewControllerNoWrapping:tabController];
 *
 */
@interface RTContainerNavigationController : UINavigationController
@end



/*!
 *  @class RTRootNavigationController
 *  @superclass UINavigationController
 *  @coclass RTContainerController
 *  @coclass RTContainerNavigationController
 */
IB_DESIGNABLE // IB_DESIGNABLE
@interface RTRootNavigationController : UINavigationController

/*!
 *  @brief 使用系统初始化的back bar  , 默认为 NO
 *  自定义的back bar：  -(UIBarButtonItem*)customBackItemWithTarget:action:
 *  @warning Set this to @b YES will @b INCREASE memory usage!
 */
@property (nonatomic, assign) IBInspectable BOOL useSystemBackBarButtonItem;

/// Weather each individual navigation bar uses the visual style of root navigation bar  , 默认为 NO
@property (nonatomic, assign) IBInspectable BOOL transferNavigationBarAttributes;

/*!
 *  @brief 使用这个属性代替 visibleViewController 去获取当前 visiable 控制器
 */
@property (nonatomic, readonly, strong) UIViewController *rt_visibleViewController;

/*!
 *  @brief 使用这个属性代替 topViewController 去获取当前 栈顶 控制器
 */
@property (nonatomic, readonly, strong) UIViewController *rt_topViewController;

/*!
 *  @brief 使用这个属性 去获取当前 所有的 控制器数组
 */
@property (nonatomic, readonly, strong) NSArray <__kindof UIViewController *> *rt_viewControllers;

/**
 *   初始化一个不包含navigation 的 根控制器
 *
 *  @param rootViewController 根控制器
 *
 *  @return new instance
 */
- (instancetype)initWithRootViewControllerNoWrapping:(UIViewController *)rootViewController;

/*!
 *  @brief 从栈中移除控制器
 *
 *  @param controller the content view controller
 */
- (void)removeViewController:(UIViewController *)controller NS_REQUIRES_SUPER;
- (void)removeViewController:(UIViewController *)controller animated:(BOOL)flag NS_REQUIRES_SUPER;

/*!
 *  @brief 当动画完成时， 跳转控制器
 *
 *  @param viewController new view controller
 *  @param animated       use animation or not
 *  @param block          animation complete callback block
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                  complete:(void(^)(BOOL finished))block;

/*!
 *  @brief 弹出控制器
 *
 *  @param animated       use animation or not
 *  @param block          complete handler
 *
 *  @return The current UIViewControllers(content controller) poped from the stack
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated complete:(void(^)(BOOL finished))block;

/*!
 *  @brief 弹出到指定的控制器
 *
 *  @param viewController The view controller to pop  to
 *  @param animated       use animation or not
 *  @param block          complete handler
 *
 *  @return A array of UIViewControllers(content controller) poped from the stack
 */
- (NSArray <__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                      animated:(BOOL)animated
                                                      complete:(void(^)(BOOL finished))block;

/*!
 *  @brief 弹出到根控制器
 *
 *  @param animated use animation or not
 *  @param block    complete handler
 *
 *  @return A array of UIViewControllers(content controller) poped from the stack
 */
- (NSArray <__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
                                                                  complete:(void(^)(BOOL finished))block;
@end
