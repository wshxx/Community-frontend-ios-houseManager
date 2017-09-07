// Copyright (c) 2016 rickytan <ricky.tan.xin@gmail.com>
//

#import <UIKit/UIKit.h>

@class RTRootNavigationController;

IB_DESIGNABLE
@interface UIViewController (RTRootNavigationController)

/*!
 *  @brief 这个属性为 YES 时 ，禁止 interactive pop
 */
@property (nonatomic, assign) IBInspectable BOOL rt_disableInteractivePop;

/*!
 *  @brief @c self.navigationControlle获取到 包含的 UINavigationController, 使用这个属性获取真实的导航控制器
 */
@property (nonatomic, readonly, strong) RTRootNavigationController *rt_navigationController;

/*!
 *  @brief Override 这个方法提供自定义的 UINavigationBar 子类, 默认返回nil
 *
 *  @return new UINavigationBar class
 */
- (Class)rt_navigationBarClass;

/*!
 *  @brief Override 这个方法提供自定义的  back bar item, 默认 normal包含title的 UIBarButtonItem
 *
 *  @param target the action target
 *  @param action the pop back action
 *
 *  @return a custom UIBarButtonItem
 */
- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action;

@end
