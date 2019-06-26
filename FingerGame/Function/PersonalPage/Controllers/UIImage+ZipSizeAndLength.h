//
//  UIImage+ZipSizeAndLength.h
//  FingerGame
//
//  Created by lisy on 2019/6/25.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZipSizeAndLength)

- (UIImage *)compressToByte:(NSUInteger)maxLength;
//直接调用这个方法进行压缩体积,减小大小
- (UIImage *)zip;

@end

NS_ASSUME_NONNULL_END
