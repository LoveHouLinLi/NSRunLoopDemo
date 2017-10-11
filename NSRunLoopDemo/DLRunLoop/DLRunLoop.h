//
//  DLRunLoop.h
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/10.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSingle.h"
#import <UIKit/UIKit.h>

typedef BOOL (^DLRunLoopBlock) (void);

@interface DLRunLoop : NSObject

DLSINGLE_H(Instance)

/**
 最大的任务加载数目 我们需要设置一个默认的数值
 */
@property (nonatomic,assign)NSUInteger maxQueue;

// 添加任务
- (void)addTask:(DLRunLoopBlock )unit withId:(id)key;
// 移除所有任务
- (void)removeAllTasks;

@end


// 这里我们使用 NSRuntime 为UITableViewCell 动态添加一个属性
@interface UITableViewCell (DLRunLoop)

// 即将 展示的cell 的indexPath
@property (nonatomic,strong)NSIndexPath *willShowIndexPath;

@end






























