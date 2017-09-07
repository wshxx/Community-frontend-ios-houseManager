//
//  WDGLocalStreamOptions.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/7/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 视频质量选项。

 - WDGVideoDimensions360p: 视频尺寸 352x288
 - WDGVideoDimensions480p: 视频尺寸 640x480
 - WDGVideoDimensions720p: 视频尺寸 1280x720
 - WDGVideoDimensions1080p: 暂不支持，设置此选项视频尺寸为 1280x720
 */
typedef NS_ENUM(NSUInteger, WDGVideoDimensions) {
    WDGVideoDimensions360p,
    WDGVideoDimensions480p,
    WDGVideoDimensions720p,
    WDGVideoDimensions1080p, 
};

NS_ASSUME_NONNULL_BEGIN

/**
 本地视频流配置。
 */
@interface WDGLocalStreamOptions : NSObject

/**
 本地媒体流的音频开关。默认为开。
 */
@property (nonatomic, assign) BOOL shouldCaptureAudio;

/**
 本地媒体流的视频开关，默认为开。
 */
@property (nonatomic, assign) BOOL shouldCaptureVideo;

/**
 视频质量选项。默认为 `WDGVideoDimensions480p`。
 */
@property (nonatomic, assign) WDGVideoDimensions dimension;

/**
 表示最大的视频帧率，默认为16fps。
 */
@property (nonatomic, assign) int maxFPS;

/**
 使用默认配置初始化。默认配置为音频开启，视频质量使用 `WDGVideoDimensions480p` 选项。

 @return `WDGLocalStreamOptions`实例。
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
