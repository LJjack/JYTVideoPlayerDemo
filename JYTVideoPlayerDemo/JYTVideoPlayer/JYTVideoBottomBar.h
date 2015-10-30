//
//  JYTVideoBottomBar.h
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTVideoSlider.h"
@class JYTVideoBottomBar;

@protocol JYTVideoBottomBarDelegate <NSObject>

/**
 *  点击播放按钮
 *
 *  @param bar     工具条
 *  @param playBtn 播放按钮
 */
- (void)videoBottomBar:(JYTVideoBottomBar *)bar clickPlayBtn:(UIButton *)playBtn;

@end

@interface JYTVideoBottomBar : UIView

@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, strong) UILabel * leftTimeLbl;
@property (nonatomic, strong) UILabel * rightTimeLbl;
@property (nonatomic, strong) JYTVideoSlider * videoSlider;
@property (nonatomic, assign) BOOL isPlay;

@property (nonatomic, weak) id<JYTVideoBottomBarDelegate> delegate;

@end
