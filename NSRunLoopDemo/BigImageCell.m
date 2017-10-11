//
//  BigImageCell.m
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/10.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#import "BigImageCell.h"

@implementation BigImageCell
{
    
    __weak IBOutlet UIImageView *leftImgView;
    
    __weak IBOutlet UIImageView *middleImgView;
    
    __weak IBOutlet UIImageView *rightImgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cleanImageView
{
    if (leftImgView.image) {
        leftImgView.image = nil;
    }
    
    if (middleImgView.image) {
        middleImgView.image = nil;
    }
    
    if (middleImgView.image) {
        rightImgView.image = nil;
    }
}

- (void)setImageView
{
    leftImgView.image = [UIImage imageNamed:@"bigImage"];
    middleImgView.image = [UIImage imageNamed:@"bigImage"];
    rightImgView.image = [UIImage imageNamed:@"bigImage"];
}


- (void)addLeftImage
{
    leftImgView.image = [UIImage imageNamed:@"bigImage"];
}

- (void)addMiddleImage
{
    middleImgView.image = [UIImage imageNamed:@"bigImage"];
}

- (void)addRightImage
{
    rightImgView.image = [UIImage imageNamed:@"bigImage"];
}


@end
