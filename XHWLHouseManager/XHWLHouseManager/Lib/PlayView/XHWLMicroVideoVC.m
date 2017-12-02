//
//  XHWLMicroVideoVC.m
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/29.
//  Copyright © 2017年 XHWL. All rights reserved.
//

#import "XHWLMicroVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "MicroVideoView.h"

@interface XHWLMicroVideoVC ()<MicroVideoDelegate>

@end

@implementation XHWLMicroVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addMicroVideoView];
}


// 点击小视频
- (void)moreVideVideoAction
{
    // 隐藏键盘
//    [self hiddenKeyBoard];
    
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (videoStatus ==     AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied) {
            // 没有权限
            NSLog(@"请在设备的\"设置-隐私-相机\"中允许访问相机");
            
//            [[JZMCustomAlertView sharedAlertView] alertTitle:@"提示"
//                                                     message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
//                                                    btnTitle:@"确定"
//                                                confirmBlock:^{
//
//                                                }];
            return;
        }
        
        AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (audioStatus ==     AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied) {
            // 没有权限
            NSLog(@"请在设备的\"设置-隐私-麦克风\"中允许访问麦克风。");
//            [[JZMCustomAlertView sharedAlertView] alertTitle:@"提示"
//                                                     message:@"请在设备的\"设置-隐私-麦克风\"中允许访问麦克风。"
//                                                    btnTitle:@"确定"
//                                                confirmBlock:^{
//
//                                                }];
            return;
        }
        __weak typeof(self) ws = self;
        if (videoStatus == AVAuthorizationStatusNotDetermined) {
            //请求相机权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                if(granted) {
                    AVAuthorizationStatus audio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                    if (audio == AVAuthorizationStatusNotDetermined) {
                        //请求麦克风权限
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (granted) {
                                    [ws addMicroVideoView];
                                }
                            });
                        }];
                    } else {//这里一定是有麦克风权限了
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ws addMicroVideoView];
                        });
                    }
                }
                
            }];
        } else {//这里一定是有相机权限了
            if (audioStatus == AVAuthorizationStatusNotDetermined) {
                //请求麦克风权限
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            [ws addMicroVideoView];
                        }
                    });
                    
                }];
            } else {//这里一定是有麦克风权限了
                [ws addMicroVideoView];
            }
        }
    }
}

#pragma mark - MyMoreViewDelegate自调方法

- (void)addMicroVideoView
{
    CGFloat selfWidth  = self.view.bounds.size.width;
    CGFloat selfHeight = self.view.bounds.size.height;
    MicroVideoView *microVideoView = [[MicroVideoView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, selfHeight)]; // * 2/3
    microVideoView.delegate = self;
    [self.view addSubview:microVideoView];
//    [[UIApplication sharedApplication].keyWindow addSubview:microVideoView];
}

#pragma mark - MicroVideoDelegate

- (void)touchUpDone:(NSString *)savePath thumImage:(UIImage *)thumImage
{
    NSLog(@"savePath: %@", savePath);
    NSError *err = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:savePath] options:NSDataReadingMappedIfSafe error:&err];
    //文件最大不超过28MB
    if(data.length < 28 * 1024 * 1024) {
//        IMAMsg *msg = [IMAMsg msgWithVideoPath:savePath];
//        [self sendMsg:msg];
        NSLog(@"发送的文件中。。。"); // 返回缩略图和对应的data
        
//        /private/var/mobile/Containers/Data/Application/5A22FA2C-3AB5-4DD3-8A8D-13F3D1617ECD/tmp/record_video_mp4_533614795.mp4
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchUpDone:data:)]) {
            [self.delegate touchUpDone:thumImage data:data];
        }
    } else {
        NSLog(@"发送的文件过大");
//        [MBProgressHUD showError:@"发送的文件过大"];
    }
}

- (void)touchBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self removeFromSuperview]; // 窗口
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
