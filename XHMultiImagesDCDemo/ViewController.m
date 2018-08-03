//
//  ViewController.m
//  XHMultiImagesDCDemo
//
//  Created by xiaohui on 2018/8/2.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "ViewController.h"
//#import "DCTool.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"

#define BaiduLogoURL @"https://www.baidu.com/img/bd_logo1.png?where=super"

#define MineImageURLCommonPart @"https://raw.githubusercontent.com/wiki/xiaohuiCoding/blogImages/Demo/resource_20180611_"

#define CommonWidth 135
#define CommonHeight 64.5

@interface ViewController ()

@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) UIImage *image4;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray = [NSMutableArray array];
    [self setUpUI];
}

- (void)setUpUI
{
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.resultImageView];
    
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.actionButton setCenter:CGPointMake(self.view.center.x, 80)];
    [self.actionButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(beginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];
}

- (void)beginAction
{
    [self downLoadAndCompound];
}

- (void)downLoadAndCompound
{
    /*****实现分组并发网络请求*****/
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    //创建GCD队列
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //执行异步下载
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"异步下载1");
//        NSURL*url = [NSURL URLWithString:BaiduLogoURL];
        NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png", MineImageURLCommonPart, 0]];
        NSData*data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self.imageArray addObject:image];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"异步下载2");
//        NSURL*url = [NSURL URLWithString:BaiduLogoURL];
        NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png", MineImageURLCommonPart, 1]];
        NSData*data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self.imageArray addObject:image];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"异步下载3");
//        NSURL*url = [NSURL URLWithString:BaiduLogoURL];
        NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png", MineImageURLCommonPart, 2]];
        NSData*data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self.imageArray addObject:image];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"异步下载4");
//        NSURL*url = [NSURL URLWithString:BaiduLogoURL];
        NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png", MineImageURLCommonPart, 3]];
        NSData*data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self.imageArray addObject:image];
        }
    });
    
    //合成图片
    dispatch_group_notify(group, queue, ^{
        
        NSLog(@"下载结束，开始合成，显示要回到主线程！");
        
        //开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(CommonWidth, CommonHeight*self.imageArray.count));
        //绘图
        for (NSInteger i = 0; i<self.imageArray.count; i++) {
            [self.imageArray[i] drawInRect:CGRectMake(0, CommonHeight*i, CommonWidth, CommonHeight)];
        }
        //根据图形上下文拿到图片
        UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self.resultImageView setFrame:CGRectMake(0, 0, CommonWidth, CommonHeight*self.imageArray.count)];
            self.resultImageView.center = self.view.center;
            self.resultImageView.image = image;
        });
        
    });
    
    //    dispatch_barrier_sync(queue, ^{
    //        NSLog(@"下载结束，开始组合，显示要回到主线程");
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.imgView.image = self.resultImage;
    //        });
    //    });
}

@end
