//
//  XHWLMicroVideoVC.h
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/29.
//  Copyright © 2017年 XHWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHWLMicroVideoVCDelegate <NSObject>

- (void)touchUpDone:(UIImage *)image data:(NSData *)data;

@end

@interface XHWLMicroVideoVC : UIViewController

@property (nonatomic, weak) id<XHWLMicroVideoVCDelegate> delegate;

@end
