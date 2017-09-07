//
//  WDGLocalStream.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/23/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import "WDGStream.h"

@class WDGLocalStreamOptions;
@class WDGLocalStream;

NS_ASSUME_NONNULL_BEGIN


/**
 处理视频流并返回。视频流格式为 'kCVPixelFormatType_420YpCbCr8BiPlanarFullRange'。
 如果返回空，则丢弃当前帧图片。
 */
@protocol WDGLocalStreamDelegate <NSObject>

@optional
- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

/**
 `WDGLocalStream` 继承自 `WDGStream` ，具有 `WDGStream` 所有的方法。
 */
@interface WDGLocalStream : WDGStream

@property (weak, nonatomic, nullable) id<WDGLocalStreamDelegate> delegate;

/**
 继承自 `NSObject` 的初始化方法不可用。

 @return 无效的 `WDGLocalStream` 实例。
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 切换摄像头。
 */
- (void)switchCamera;

@end

NS_ASSUME_NONNULL_END
