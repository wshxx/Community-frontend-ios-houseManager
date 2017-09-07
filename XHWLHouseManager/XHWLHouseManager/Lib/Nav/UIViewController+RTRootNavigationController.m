// Copyright (c) 2016 rickytan <ricky.tan.xin@gmail.com>
//

#import <objc/runtime.h>

#import "UIViewController+RTRootNavigationController.h"
#import "RTRootNavigationController.h"

@implementation UIViewController (RTRootNavigationController)
@dynamic rt_disableInteractivePop;

- (void)setRt_disableInteractivePop:(BOOL)rt_disableInteractivePop
{
    objc_setAssociatedObject(self, @selector(rt_disableInteractivePop), @(rt_disableInteractivePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_disableInteractivePop
{
    return [objc_getAssociatedObject(self, @selector(rt_disableInteractivePop)) boolValue];
}

- (Class)rt_navigationBarClass
{
    return nil;
}

- (RTRootNavigationController *)rt_navigationController
{
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[RTRootNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (RTRootNavigationController *)vc;
}

- (UIBarButtonItem *)customBackItemWithTarget:(id)target
                                       action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
}

@end
