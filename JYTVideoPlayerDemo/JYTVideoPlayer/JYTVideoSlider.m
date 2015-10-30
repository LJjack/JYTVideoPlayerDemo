//
//  JYTVideoSlider.m
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "JYTVideoSlider.h"

#define kSubLineWidth (self.frame.size.width - 18)

@interface JYTVideoSlider ()

@property (nonatomic,strong) UIView * subLine;

@end

@implementation JYTVideoSlider

-(UIView *)subLine{
    if (!_subLine) {
        _subLine = [[UIView alloc] initWithFrame:CGRectMake(16, self.frame.size.height / 2 - 1, 0, 2)];
        _subLine.layer.cornerRadius = 1;
        _subLine.clipsToBounds = YES;
        _subLine.backgroundColor = [UIColor whiteColor];
        [self insertSubview:_subLine atIndex:0];
    }
    return _subLine;
}

-(void)setSubValue:(float)subValue{
    if(_subValue >= subValue)return;
    _subValue = subValue;
    
    if (self.maximumValue <= 1) {
        return;
    }
    
    CGRect frame = self.subLine.frame;
    float rate = (_subValue / self.maximumValue);
    if(rate >= .98)rate = 1;
    frame.size.width = (float)kSubLineWidth * rate;
    [UIView animateWithDuration:.2 animations:^{
        _subLine.frame = frame;
    }];
    
}


@end
