//
//  ViewController.m
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/7.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    主要介绍NSRunLoop 的 部分概念 但是 笔者认为 有些概念还是得实验一下为好
 */

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSThread *threadOne;

@property (nonatomic,strong)NSThread *threadTwo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self timerFire];
//    [self runloopTimer];
    
//    [self threadPerformaceInRunLoop];
    
    
    [ViewController observerTest];
    
//    [ViewController nestTest];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----  setter getter
- (NSThread *)threadOne
{
    if (!_threadOne) {
        _threadOne = [[NSThread alloc] initWithBlock:^{
            NSLog(@"this is thread one");
        }];
        [_threadOne start];  //  首先要开启一个线程  不开启的话没有效果
    }
    return _threadOne;
}

- (NSThread *)threadTwo
{
    if (!_threadTwo) {
        _threadTwo = [[NSThread alloc] initWithBlock:^{
            NSLog(@"this is thread two ");
        }];
        
        [_threadTwo start];
    }
    return _threadTwo;
}


#pragma mark ----  nsrunloop thread expri
- (void)timerFire
{
    NSRunLoopMode currentRunLoopMode = [[NSRunLoop currentRunLoop] currentMode];
    NSLog(@"mode is: %@",currentRunLoopMode);
}

// runloop timer demo
- (void)runloopTimer
{
    //
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *tickTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:2.0 target:self selector:@selector(modeTestTimerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
        
        // 一直运行这个timer
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    });
}


- (void)modeTestTimerMethod
{
    NSLog(@"mode test timer method ");
}

#pragma mark ---- SelectorOnThread
/*
 只要记住没有延迟或者等待的都不会添加到runloop，
 有延迟或者等待的还有排除上面提到的特殊情况。
 */
- (void)threadPerformaceInRunLoop
{
    // 针对 主线程的runloop
//    [self performSelectorOnMainThread:@selector(modeTestTimerMethod) withObject:nil waitUntilDone:YES];
//    NSArray *modes = [NSArray arrayWithObject:NSDefaultRunLoopMode];
//    [self performSelectorOnMainThread:@selector(modeTestTimerMethod) withObject:nil waitUntilDone:YES modes:modes];
    
    // 在特定的线程 执行某个方法
    [self performSelector:@selector(modeTestTimerMethod) onThread:self.threadOne withObject:nil waitUntilDone:NO];
    NSLog(@"method finished ");
    
}

- (void)threadPerformaceNotInRunLoop
{
    
}

#pragma mark ----  Observer Demo

// 这个 方法 演示了 runloop 的生命周期
+ (void)observerTest
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            
            switch (activity) {
                case kCFRunLoopEntry:{
                    NSLog(@"即将 进入 runloop");
                }
                    break;
                case kCFRunLoopBeforeTimers:{
                    NSLog(@"即将 处理 timer");
                }
                    break;
                case  kCFRunLoopBeforeSources:
                {
                    NSLog(@"即将 处理 input source");
                }
                    break;
                case  kCFRunLoopBeforeWaiting:
                {
                    NSLog(@"即将 睡眠");
                }
                    break;
                case  kCFRunLoopAfterWaiting:
                {
                    NSLog(@"从睡眠中 唤醒，处理完 唤醒源 之前");
                }
                    break;
                case kCFRunLoopExit:
                {
                    NSLog(@"退出 ");
                }
                    break;
                default:
                {
                    NSLog(@"nsrunloop unknow state ");
                }
                    break;
            }
        });
        
        
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(doFireTimer) userInfo:nil repeats:YES];
        CFRunLoopAddObserver([[NSRunLoop currentRunLoop] getCFRunLoop], observer, kCFRunLoopDefaultMode);
        [[NSRunLoop currentRunLoop] run];
        
    });
}


+ (void)doFireTimer {
    NSLog(@"---fire---");
}

#pragma mark ---- RunLoop 嵌套测试
+ (void)nestTest
{
    // 在另外一个 子线程中开启 runloop
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *tickTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:2 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
        
        //  使用限定的时间 来终止 runloop的时间
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];   //
        NSLog(@"-- end ---");
        
    });
}



/**
 不停的 运行 和 退出 最内层 runloop
 */
+ (void)timerHandler
{
    // 查看当前的 runloop 的运行mode
//    NSLog(@"timer11 - %@ runtloop is: %@",[[NSRunLoop currentRunLoop] currentMode],[NSRunLoop currentRunLoop]);
    //
    NSLog(@"timer11 - %@ ",[[NSRunLoop currentRunLoop] currentMode]);
    static dispatch_once_t onceToken;
    
    // 防止 多次添加 timer， 开发中应特别注意
    dispatch_once(&onceToken, ^{
        NSLog(@" add tick timer2");  // 只添加了一次 timer
        NSTimer *tickTimer2 = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(timerHandler2) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer2 forMode:UITrackingRunLoopMode];
    });
    
    // 内部循环
    [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate distantFuture]];
    
}

// 第二个加入 timer2 中的方法
+ (void)timerHandler2
{
//    NSLog(@"timer222 - %@ runloop is: %@",[[NSRunLoop currentRunLoop] currentMode],[NSRunLoop currentRunLoop]);
    NSLog(@"timer222 - %@",[[NSRunLoop currentRunLoop] currentMode]);
    CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
}

























































































































@end
