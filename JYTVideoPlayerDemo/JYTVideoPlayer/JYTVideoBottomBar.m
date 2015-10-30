//
//  JYTVideoBottomBar.m
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "JYTVideoBottomBar.h"

@implementation JYTVideoBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn setImage:[UIImage imageNamed:@"playback_play"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"playback_pause"] forState:UIControlStateSelected];
        [self.playBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playBtn];
        self.isPlay = NO;
        
        self.leftTimeLbl = [[UILabel alloc]init];
        self.leftTimeLbl.text = @"00:00";
        self.leftTimeLbl.textColor = [UIColor whiteColor];
        self.leftTimeLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.leftTimeLbl];
        
        self.rightTimeLbl = [[UILabel alloc]init];
        self.rightTimeLbl.text = @"00:00";
        self.rightTimeLbl.textColor = [UIColor whiteColor];
        self.rightTimeLbl.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.rightTimeLbl];
        
        self.videoSlider = [[JYTVideoSlider alloc]init];
        self.videoSlider.minimumTrackTintColor = [UIColor greenColor];
        self.videoSlider.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.videoSlider];


    }
    return self;
}

-(void)layoutSubviews{
    self.playBtn.frame = CGRectMake(self.frame.size.width * 0.03, 3, 44, 44);
    self.leftTimeLbl.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + self.frame.size.width * 0.025, 8, 40, 34);
    self.rightTimeLbl.frame = CGRectMake(CGRectGetMaxX(self.frame) - self.frame.size.width * 0.03 - 40, 8 , 40, 34);
    self.videoSlider.frame  = CGRectMake(CGRectGetMaxX(self.leftTimeLbl.frame) + 12, 0,self.rightTimeLbl.frame.origin.x - 24 -  CGRectGetMaxX(self.leftTimeLbl.frame) , 50);
    
}

- (void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    self.playBtn.selected = isPlay;
    
}

- (void)btnAction:(UIButton *)sender{
    self.isPlay = !self.isPlay;
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoBottomBar:clickPlayBtn:)]) {
        [self.delegate videoBottomBar:self clickPlayBtn:self.playBtn];
    }
}

@end
