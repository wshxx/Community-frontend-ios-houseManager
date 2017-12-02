//
//  MicroVideoPlayView.h
//  MicroVideo
//
//  Created by wilderliao on 16/5/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class MicroVideoFullScreenPlayView;

@interface MicroVideoPlayView : UIView
{
//    IMAMsg *_msg;
    NSURL   *_videoURL;
    UIImage *_coverImage;
    NSString *_dataUrl;
    
    UIButton        *_playerBtn;
    
    AVPlayerItem    *_playItem;
    AVPlayer        *_player;
    AVPlayerLayer   *_playerLayer;
    BOOL            _isPlaying;
    
    CGRect          _selfFrame;
}

@property (nonatomic, strong) NSURL   *videoURL;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) MicroVideoFullScreenPlayView *fullScreen;
@property (nonatomic, copy) NSString *videoPath;
//- (void)setMessage:(IMAMsg *)msg;

// 显示图片和本身内容
- (void)setContentUrl:(NSString *)url;

- (void)relayoutSubViews;

@end

@interface MicroVideoFullScreenPlayView : MicroVideoPlayView
- (void)dismissScaling;
@end
