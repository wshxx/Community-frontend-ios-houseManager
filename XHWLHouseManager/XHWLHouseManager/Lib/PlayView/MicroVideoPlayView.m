//
//  MicroVideoPlayView.m
//  MicroVideo
//
//  Created by wilderliao on 16/5/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "MicroVideoPlayView.h"

#import <AVKit/AVKit.h>

#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@implementation MicroVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _selfFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        [self addSubviews];
        [self configSubviews];
        [self relayoutSubViews];
        
        [self addObserver];
    }
    return self;
}


- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndPlay:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScaling:)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews
{
    _playerLayer = [AVPlayerLayer layer];
    [self.layer addSublayer:_playerLayer];
    
     _playerBtn = [[UIButton alloc] init];
    [self addSubview:_playerBtn];
}

- (void)configSubviews
{
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.masksToBounds = YES;
    
    [_playerBtn setBackgroundColor:[UIColor clearColor]];
    [_playerBtn setImage:[UIImage imageNamed:@"record_playbutton"] forState:UIControlStateNormal];
    [_playerBtn setImage:[UIImage imageNamed:@"record_errorbutton"] forState:UIControlStateDisabled];
    _playerBtn.userInteractionEnabled = NO;
//    [_playerBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
}


// 显示图片和本身内容
- (void)setContentUrl:(NSString *)url
{
    [self showCoverUrl:url];
}

//- (void)setMessage:(IMAMsg *)msg
//{
//    _msg = msg;
//    [self setCoverImage];
//}

//设置小视频消息封面图片
- (void)showCoverUrl:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/png/offset/1/w/200/h/200", url]]];
    UIImage *image = [UIImage imageWithData:data];
    
    _videoPath = url;
//    _videoImage = image;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataUrl]];
//    UIImage *image = [UIImage imageWithData:data];
    self.coverImage = image;
    self.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
    
    
    
//    TIMVideoElem *elem = (TIMVideoElem *)[_msg.msg getElem:0];

    //将封面截图保存到 “Caches/当前登陆用户ID/截图UUID” 路径

//    NSString *hostCachesPath = [self getHostCachesPath];
//    if (!hostCachesPath)
//    {
//        return;
//    }
//
//    // 显示缩略图
//    NSString *imagePath = [NSString stringWithFormat:@"%@/snapshot_%@", hostCachesPath, elem.snapshot.uuid];
//
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    if (elem.snapshotPath && [fileMgr fileExistsAtPath:elem.snapshotPath]) {
//        UIImage *image = [UIImage imageWithContentsOfFile:elem.snapshotPath];
//        _coverImage = image;
//        _playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
//    } else  {
//        __weak MicroVideoPlayView *ws = self;
//        if (elem.snapshot.uuid && elem.snapshot.uuid.length > 0) {
//            [elem.snapshot getImage:imagePath succ:^{
//                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//                ws.coverImage = image;
//                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
//            } fail:^(int code, NSString *msg) {
//                UIImage *image = [UIImage imageNamed:@"default_video"];
//                ws.coverImage = image;
//                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
////                [MBProgressHUD showError:IMALocalizedError(code, err)];
//            }];
//        }
//    }
}

//- (void)downloadVideo:(TIMSucc)succ fail:(TIMFail)fail
//{
//    TIMVideoElem *elem = (TIMVideoElem *)[_msg.msg getElem:0];
//
//    if (!(elem.video.uuid && elem.video.uuid.length > 0))
//    {
//        NSLog(@"小视频UUID为空");
//        if (fail)
//        {
//            fail(-1, @"小视频UUID为空");
//        }
//        return;
//    }
//
//    NSString *hostCachesPath = [self getHostCachesPath];
//    if (!hostCachesPath)
//    {
//        NSLog(@"获取本地路径出错");
//        if (fail)
//        {
//            fail(-2, @"获取本地路径出错");
//        }
//        return;
//    }
//
//    NSString *videoPath = [NSString stringWithFormat:@"%@/video_%@.%@", hostCachesPath, elem.video.uuid, elem.video.type];
//
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//
//    if ([fileMgr fileExistsAtPath:videoPath isDirectory:nil])
//    {
//        _videoURL = [NSURL fileURLWithPath:videoPath];
//        [self initPlayer];
//        if (succ)
//        {
//            succ();
//        }
//    }
//    else
//    {
//        __weak MicroVideoPlayView *ws = self;
//        [elem.video getVideo:videoPath succ:^{
//            ws.videoURL = [NSURL fileURLWithPath:videoPath];
//            [ws initPlayer];
//            if (succ)
//            {
//                succ();
//            }
//        } fail:^(int code, NSString *err) {
//            [MBProgressHUD showError:IMALocalizedError(code, err)];
//            if (fail)
//            {
//                fail(code,err);
//            }
//        }];
//    }
//}

// 获取本地路径
//- (NSString *)getHostCachesPath
//{
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
//    NSString *cachesPath =[cachesPaths objectAtIndex:0];
//    NSString *hostCachesPath = [NSString stringWithFormat:@"%@/%@",cachesPath, [IMAPlatform sharedInstance].host.profile.identifier];
//
//    if (![fileMgr fileExistsAtPath:hostCachesPath])
//    {
//        NSError *err = nil;
//
//        if (![fileMgr createDirectoryAtPath:hostCachesPath withIntermediateDirectories:YES attributes:nil error:&err])
//        {
//            NSLog(@"Create HostCachesPath fail: %@", err);
//            return nil;
//        }
//    }
//    return hostCachesPath;
//}

- (void)initPlayer
{
    _playItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player   = [AVPlayer playerWithPlayerItem:_playItem];
    
    [_playerLayer setPlayer:_player];
}

- (void)onPlay:(UIButton *)button
{
    [self onPlay];
//    [self downloadVideo:^{
//
//        [_player play];
//        button.hidden = YES;
//
//    } fail:nil];
}

- (void)onPlay
{
    self.videoURL = [NSURL URLWithString:self.videoPath];
    NSLog(@" videoURL: %@ , %@", self.videoURL, self.videoPath);
    [self initPlayer];
    [_player play];
    _playerBtn.hidden = YES;

    
//    [self downloadVideo:^{
//        _playerBtn.hidden = YES;
//        [_player play];
//    } fail:nil];
}

- (void)downloadVideo:(NSString *)videoPath //:(TIMSucc)succ fail:(TIMFail)fail
{

//    NSString *hostCachesPath = [self getHostCachesPath];
//    if (!hostCachesPath)
//    {
//        NSLog(@"获取本地路径出错");
//        if (fail)
//        {
//            fail(-2, @"获取本地路径出错");
//        }
//        return;
//    }

//    NSString *videoPath = [NSString stringWithFormat:@"%@/video_%@.%@", hostCachesPath, elem.video.uuid, elem.video.type];

//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//
//    if ([fileMgr fileExistsAtPath:videoPath isDirectory:nil])
//    {
//        _videoURL = [NSURL fileURLWithPath:videoPath];
//        [self initPlayer];
//        if (succ)
//        {
//            succ();
//        }
//    }
//    else
//    {
        __weak MicroVideoPlayView *ws = self;
    
    
//        [elem.video getVideo:videoPath succ:^{
//            ws.videoURL = [NSURL fileURLWithPath:videoPath];
    
    self.videoURL = [NSURL URLWithString:videoPath];
            [self initPlayer];
//            if (succ)
//            {
//                succ();
//            }
//        } fail:^(int code, NSString *err) {
//            [MBProgressHUD showError:IMALocalizedError(code, err)];
//            if (fail)
//            {
//                fail(code,err);
//            }
//        }];
//    }
}


-(void)onEndPlay:(NSNotification *)notification
{
    AVPlayerItem *item = (AVPlayerItem *)notification.object;
    if (_playItem == item)
    {
        _playerBtn.hidden = NO;
        [_player seekToTime:CMTimeMake(0, 1)]; // 跳到最新的时间点开始播放
        [self dismissScaling];
    }
}

- (void)stopPlay
{
    _playerBtn.hidden = NO;
    _playItem = nil;
    _player = nil;
    _playerLayer.player = nil;
//    [_player seekToTime:CMTimeMake(0, 1)];
    [self dismissScaling];
}

- (void)onScaling:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGRect screen = [UIScreen mainScreen].bounds;
    _fullScreen = [[MicroVideoFullScreenPlayView alloc] initWithFrame:screen];
//    [_fullScreen setMessage:_msg];
    [_fullScreen showCoverUrl:_videoPath];
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_fullScreen];
    
    [_fullScreen onPlay];
}

- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _playerLayer.frame = self.bounds;
    
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    _msg = nil;
    _videoURL = nil;
    _coverImage = nil;
    _playerBtn = nil;
    _playItem = nil;
    _player = nil;
    _playerLayer = nil;
}

- (void)dismissScaling
{
//    [self removeFromSuperview];
}

@end

/////////////////////////////////////////////////////
@implementation MicroVideoFullScreenPlayView

- (void)onScaling:(UITapGestureRecognizer *)tap
{
    [self stopPlay];
//    [self removeFromSuperview];
}

- (void)dismissScaling
{
    [self removeFromSuperview];
}

- (void)relayoutSubViews
{
//    CGFloat selfWidth = self.bounds.size.width;
//    CGFloat selfHeight = self.bounds.size.height;
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
//    _playerLayer.frame = CGRectMake(0, screen.size.height/3, self.bounds.size.width, self.bounds.size.height/3);
//    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
    _playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, screen.size.height);
//    _playerBtn.hidden = YES;
//    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

@end
