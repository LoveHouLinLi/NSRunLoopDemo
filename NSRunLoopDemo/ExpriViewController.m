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
    
    // textView 的滑动会阻断 timer 方法的运行
//    [ExpriViewController runloopMethodOne];
    
    // 第二个 方法
//    [ExpriViewController runloopMethodTwo];
    
    // 常驻线程
    [ExpriViewController residentThread];
}

- (void)dealloc
{
    NSLog(@"ExpriViewController  dealoc ");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- timer runloop method

/**
 我们发现在 textView 页面滑动的过程中 timer的函数 并没有 执行
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
// 常驻线程 这个线程一直在运行用于 不会回收  即使 ExpriViewController 被系统回收也不会回收
// 但是要小心 timer 被重复 添加到了runloop 中
+ (void)residentThread
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
            static int count = 0;
            // 在子线程里有个 耗时的 操作 需要1.0秒来计算
            [NSThread sleepForTimeInterval:1.0];
            
            // 打印信息
            NSLog(@"%s - %d",__func__,count++);
        }];
        
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        // ！！！！  子线程需要手动开启runloop  不然无法启动
        [[NSRunLoop currentRunLoop]  run];
    });
}





@end



































































