//
//  DCTool.m
//  XHMultiImagesDCDemo
//
//  Created by xiaohui on 2018/8/2.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "DCTool.h"
//#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface DCTool ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation DCTool

//利用SDWebImage下载图片
- (void)downLoadImageWithURLString:(NSString *)urlString
{
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //处理下载进度
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"error is %@",error);
        }
        if (image) {
            //使用数据
        }
    }];
}

@end
