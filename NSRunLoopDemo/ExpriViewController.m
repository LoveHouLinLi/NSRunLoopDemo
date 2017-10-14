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
//    [ExpriViewController residentThread];
    
    //
//    [self comapre];
    
    
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

#pragma mark ----  使用 NSRunLoop 事件监听测试


/*
 用户对ui的操作实际上是一种port，会放到一个队列中传到loop，然后由loop交给主线程处理。loop就是一个循环，接受event，传递，继续。主线程是另一个循环，负责事件的处理与界面的显示。当然这两者关系复杂。
 */
BOOL  pageStillLoading = YES;

// 这是一个对比的方法 正常的过程 在timer 没有触发前 会一直打印 while end
- (void)comapre
{
    NSLog(@"begin"); // 1
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]]; // 2
    NSLog(@"end"); //3
    
    pageStillLoading = YES;
    [NSThread detachNewThreadSelector:@selector(loadPageInBackground:) toTarget:self withObject:nil];  // 4
    while (pageStillLoading) {
        NSLog(@"while end");
    }
    
    NSLog(@"over");
}

- (IBAction)touchRunLoop:(id)sender
{
    NSLog(@"begin"); // 1
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]]; // 2
    NSLog(@"end"); //3
    
    pageStillLoading = YES;
    [NSThread detachNewThreadSelector:@selector(loadPageInBackground:) toTarget:self withObject:nil];  // 4
    while (pageStillLoading) {
        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];  // 5
        NSLog(@"while end");
    }
    
    NSLog(@"over");
}


- (void)loadPageInBackground:(id)sender
{
    sleep(3);  // 6
    NSLog(@"timer");  // 7
    pageStillLoading = NO;  // 8
}

/*
 017-10-14 14:20:10.708265+0800 NSRunLoopDemo[38300:2926258] begin
 2017-10-14 14:20:20.709459+0800 NSRunLoopDemo[38300:2926258] end
 2017-10-14 14:20:23.710106+0800 NSRunLoopDemo[38300:2926423] timer
 2017-10-14 14:21:00.005729+0800 NSRunLoopDemo[38300:2926258] while end
 2017-10-14 14:21:00.006024+0800 NSRunLoopDemo[38300:2926258] over
 我们发现：
 pageStillLoading设置成NO之后过了近30s，while才结束。
 */

/*
 如果我把5的mode改成NSRunLoopCommonModes或者在界面上在加一个按钮，然后不停的点击那个（B），结果如下
 或者我们移动 这个 textView   会频繁的打印 这些数据 所以 也会很快就结束
 关键的语句在这句：
 runMode：beforeDate：是要么接受到一个mode上的event，要么到date这个时间。所以，A中要等待很久，这句才会返回；除非是有外部的 输入激活。 就相当于一个阻塞 我们看到按钮一直处于 highlight 的状态
 */

/**/




@end



































































