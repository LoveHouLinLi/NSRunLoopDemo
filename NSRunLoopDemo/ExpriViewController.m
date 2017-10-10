//
//  ExpriViewController.m
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/9.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "ExpriViewController.h"

@interface ExpriViewController ()

@end

@implementation ExpriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [ExpriViewController runloopMethodOne];
    
    // 第二个 方法
    [ExpriViewController runloopMethodTwo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- timer runloop method

/**
 我们发现在页面滑动的过程中 timer的函数 并没有 执行
 */
+ (void)runloopMethodOne
{
    NSTimer * timer = [NSTimer timerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"expriviewcontroller ---- %s",__func__);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}



/**
 使用 runloop 的commonmodes 可以使得在拖拽的时候不影响 timer
 */
+ (void)runloopMethodTwo
{
    NSTimer * timer = [NSTimer timerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        static int count = 0;
        NSLog(@"expriviewcontroller  %s - %d",__func__,count++);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark ----  NSRunLoop 常驻线程测试
// 常驻线程
+ (void)residentThread
{
    
}





@end
