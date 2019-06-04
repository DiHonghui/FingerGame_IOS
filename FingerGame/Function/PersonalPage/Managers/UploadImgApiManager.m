//
//  UploadImgApiManager.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/28.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UploadImgApiManager.h"
#import "AFNetworking.h"
#import "ZHYNetworkingConfiguration.h"

@interface UploadImgApiManager()

@end

@implementation UploadImgApiManager

-(void)uploadCallBack:(callBack)callBack{
    /*
    此段代码如果需要修改，可以调整的位置
    1. 把upload.php改成网站开发人员告知的地址
    2. 把file改成网站开发人员告知的字段名
    */
    
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    //manager.requestSerializer.networkServiceType = 4;
    //    NSDictionary *dict = @{@"file":UIImagePNGRepresentation([UIImage imageNamed:@"doctorAvatar"])};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:[NSString stringWithFormat:@"%@?r=Examples_Upload/go",KIsOnline?KOnlineApiBaseUrl:KOfflineApiBaseUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"doctorAvatar"]);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSLog(@"\n文件名：%@\n", fileName);
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //        //上传进度
        //        // @property int64_t totalUnitCount;     需要下载文件的总大小
        //        // @property int64_t completedUnitCount; 当前已经下载的大小
        //        //
        //        // 给Progress添加监听 KVO
        //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        //        // 回到主队列刷新UI,用户自定义的进度条
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.progressView.progress = 1.0 *
        //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        callBack(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败 %@", error);
        callBack(NO);
    }];
    
    
}




@end
