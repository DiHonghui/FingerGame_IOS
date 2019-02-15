//
//  NSMutableString+ZHYNetworingMethods.m
//  ZHYNetworking
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "NSMutableString+ZHYNetworingMethods.h"

@implementation NSMutableString (ZHYNetworingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] ?:@"\t\t\t\tN/A"];
}

@end
