//
//  AudioManager.m
//  FingerGame
//
//  Created by lisy on 2019/3/26.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

//单例静态对象
static AudioManager *sInstance = nil;

@interface AudioManager()<AVAudioPlayerDelegate>

@property (strong,nonatomic) AVAudioPlayer *myAudioPlayer;

@end

@implementation AudioManager
#pragma mark - 单例对象
+ (AudioManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[AudioManager alloc] init];
    });
    NSLog(@"create AudioManager instance");
    return sInstance;
}

#pragma mark - Object Methods
- (void)downloadAudioWithURL:(NSString *)aUrl fileName:(NSString *)aFileName downloadProgressBlock:(nonnull DownloadProgressBlock)progressBlock downloadReturnBlock:(nonnull DownloadReturnBlock)returnBlock {
        /* 创建网络下载对象 */
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        /* 下载地址 */
        /* 注意汉字编码的情况，需要对urlString进行转码*/
        aUrl = [aUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
        NSLog(@"下载路径：%@",aUrl);
        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        /* 本地保存路径 */
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *afilePath = [path stringByAppendingPathComponent:aFileName];
        NSLog(@"本地目标路径：%@",afilePath);
        /* 开始请求下载 */
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //NSLog(@"下载进度：%.2f％", downloadProgress.fractionCompleted * 100);
            progressBlock(downloadProgress.fractionCompleted);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            /* 设定下载到的位置 */
            return [NSURL fileURLWithPath:afilePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error){
                NSLog(@"下载完成");
                returnBlock(YES,afilePath);
            }else{
                NSLog(@"下载发生错误%@",error);
                returnBlock(NO,@"");
            }
        }];
        [downloadTask resume];
}

- (void)prepareForAudioPlayer:(NSString *)filePath{
    if (!_myAudioPlayer) {
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        NSLog(@"fileLocalPath:%@",filePath);
        _myAudioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        //设置播放器属性
        _myAudioPlayer.numberOfLoops=0;//设置为0不循环
        _myAudioPlayer.delegate=self;
        [_myAudioPlayer prepareToPlay];//加载音频文件到缓存
        NSLog(@"ready for playing");
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        }
    }
}

- (void)prepareForAudioPlayerWithDataSet:(NSString *)audioName{
    NSDataAsset *asset = [[NSDataAsset alloc] initWithName:audioName];
    NSData *data = asset.data;
    NSError *error=nil;
    _myAudioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (_myAudioPlayer) NSLog(@"播放器成功创建");
    [_myAudioPlayer prepareToPlay];//加载音频文件到缓存
    _myAudioPlayer.numberOfLoops=0;//设置为0不循环
    _myAudioPlayer.delegate=self;
    NSLog(@"ready for playing");
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
}

- (void)playAudio{
    if (![self.myAudioPlayer isPlaying]){
        [self.myAudioPlayer play];
    }
}

- (void)pauseAudio{
    if ([self.myAudioPlayer isPlaying]){
        [self.myAudioPlayer pause];
    }
}

- (void)restartAudio{
    if (self.myAudioPlayer){
        self.myAudioPlayer.currentTime = 0;
    }
}

- (void)exitPlaying{
    NSLog(@"退出播放...");
    self.myAudioPlayer = nil;
}

#pragma mark - Private Methods

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag){
        NSLog(@"音乐播放完成...");
        self.myAudioPlayer = nil;
    }
}

@end
