//
//  BigImageCellViewController.m
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/10.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    这个viewController 主要是为了对比
    使用 nsrunloop 来分批加载cell 并且只在滑动停止的情况下加载图片
    实际上: 在真实的应用中 列表中都是缩略图 点击小图查看大图 这是在移动端
    经常优化的方法。
    在一些大图 加载的时候 我们采取加载一张卸载一张的策略 也就是用户看到的始终
    只有一个大图 没有
 */

#import "BigImageCellViewController.h"
#import "BigImageCell.h"
#import "DLRunLoop.h"


@interface BigImageCellViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BigImageCellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BigImageCell" bundle:nil] forCellReuseIdentifier:@"xibCell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[DLRunLoop shareInstance] removeAllTasks];
}




/*
    每个图片的大小大约为 336KB
 */
#pragma mark ---- UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xibCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.willShowIndexPath = indexPath;
    [cell cleanImageView];
    
    #if 1   // 是否开启runloop优化
    
    [[DLRunLoop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexPath isEqual:indexPath]) {
            return NO;
        }
        [cell addLeftImage];
        // NSLog(@"add left image");
        return YES;
    } withId:indexPath];
    
    [[DLRunLoop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexPath isEqual:indexPath]) {
            return NO;
        }
        [cell addRightImage];
        return YES;
    } withId:indexPath];
    
    [[DLRunLoop shareInstance] addTask:^BOOL{
        if (![cell.willShowIndexPath isEqual:indexPath]) {
            return NO;
        }
        [cell addMiddleImage];

        return YES;
    } withId:indexPath];
    
    #else
    [cell setImageView];
    #endif
    
    return  cell;
}





#pragma mark ----  UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at indexPath");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
