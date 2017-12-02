//
//  MicroVideoView.h
//  MicroVideo
//
//  Created by wilderliao on 16/5/16.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFProgressView.h"

@protocol MicroVideoDelegate <NSObject>

- (void)touchUpDone:(NSString *)savePath thumImage:(UIImage *)thumImage;
- (void)touchBack;

@end

@interface MicroVideoView : UIImageView
{
    UIButton        *_fontOrBack;
    UILabel         *_timeL;
    UIButton        *_recordBtn;
    UIButton        *_cancelBtn;
    UIButton        *_finishedBtn;
    NSString        *_path;
    
//    UIView          *_upSlidePanel;
//    UIImageView     *_upSlidePic;
//    UILabel         *_upSlideText;
//    UIImageView     *_touchUpCancel;
    
    ZFProgressView  *_progressView;
    UIImageView     *_focusView;
    int             _num;
    NSTimer         *_timer;
    __weak id<MicroVideoDelegate> _delegate;
}

@property (nonatomic, weak) id<MicroVideoDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, strong) AVURLAsset *urlAsset;
@end
