//
//  ViewController.m
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/7.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    主要介绍NSRunLoop 的
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
    
    [self threadPerformaceInRunLoop];
    
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
    }
    return _threadOne;
}

- (NSThread *)threadTwo
{
    if (!_threadTwo) {
        _threadTwo = [[NSThread alloc] initWithBlock:^{
            NSLog(@"this is thread two ");
        }];
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
    
}

- (void)threadPerformaceNotInRunLoop
{
    
}


























































































































@end
