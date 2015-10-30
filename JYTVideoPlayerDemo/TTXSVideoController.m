//
//  TTXSVideoController.m
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/26.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "TTXSVideoController.h"

@implementation TTXSVideoController

- (void)clickTitleBtn{
    [super clickTitleBtn];
    NSLog(@"点击title返回按钮");
}

- (void)clickRetry{
    [super clickRetry];
    NSLog(@"点击重新播放");
}

#pragma mark 点赞事件
-(void)clickStar{
    [super clickStar];
}


/**
 *  点赞完成后的处理
 *
 *  @param title 赞数
 */
- (void)stared:(NSString *)title{

    
}

-(void)videoBottomBar:(JYTVideoBottomBar *)bar clickPlayBtn:(UIButton *)playBtn{
    [super videoBottomBar:bar clickPlayBtn:playBtn];
    if (bar.isPlay) {
        NSLog(@"播放");
    }else{
        NSLog(@"暂停");
    }
}

- (void)onDragSlideStart:(id)sender{
    [super onDragSlideStart:sender];
    NSLog(@"开始拖拽进度条");
}

- (void)onDragSlideValueChanged:(id)sender
{
    [super onDragSlideValueChanged:sender];
    NSLog(@"拖拽进度条过程中");
}

- (void)onDragSlideDone:(id)sender{
    [super onDragSlideDone:sender];
    NSLog(@"结束拖拽进度条");
}

/**
 *  视频播放回调,0.5秒每次
 */
- (void)playTick:(int)currentTime totalDuration:(int)allSecond{

    
}


@end
