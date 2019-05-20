//
//  AudioManager.h
//  FingerGame
//
//  Created by lisy on 2019/3/26.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DownloadReturnBlock)(bool state,NSString *_Nonnull localPath);
typedef void(^DownloadProgressBlock)(CGFloat p);

@interface AudioManager : NSObject
//单例
+ (AudioManager*)sharedInstance;
//从服务器下载音频文件 aUrl请求文件地址
- (void)downloadAudioWithURL:(NSString *)aUrl fileName:(NSString *)aFileName downloadProgressBlock:(DownloadProgressBlock)progressBlock downloadReturnBlock:(DownloadReturnBlock)returnBlock;
//传入本地音频文件路径，准备播放
- (void)prepareForAudioPlayer:(NSString *)filePath;
//
- (void)playAudio;
//
- (void)pauseAudio;
//
- (void)restartAudio;
//
- (void)exitPlaying;

@end

NS_ASSUME_NONNULL_END
