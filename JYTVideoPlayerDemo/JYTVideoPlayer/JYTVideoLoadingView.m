//
//  JYTVideoLoadingView.m
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/20.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "JYTVideoLoadingView.h"

@implementation JYTVideoLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView:frame];
    }
    return self;
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.frame = CGRectMake(40, 10, 44, 44);
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UILabel *)netWorkLabel{
    if (!_netWorkLabel) {
        _netWorkLabel = [[UILabel alloc] init];
        _netWorkLabel.frame = CGRectMake(CGRectGetMaxX(self.indicatorView.frame) + 11, 10, 70, 44);
        _netWorkLabel.textColor = [UIColor whiteColor];
        _netWorkLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_netWorkLabel];
    }
    return _netWorkLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.indicatorView.frame), self.frame.size.width - 20, 40)];
        _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)retryBtn{
    if (!_retryBtn) {
        _retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 25, self.frame.size.width, 50)];
        [_retryBtn setImage:[UIImage imageNamed:@"movie_retry"] forState:UIControlStateNormal];
        [_retryBtn addTarget:self action:@selector(clickRetry) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retryBtn];
    }
    return _retryBtn;
}

- (void)setUpView:(CGRect)frame{
    self.layer.cornerRadius = 10;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self.indicatorView startAnimating];
    self.netWorkLabel.text = @"0KB/s";
    self.titleLabel.text = @"正在缓冲，请稍后...";
}

- (void)showLoading{
    self.hidden = NO;
    self.indicatorView.hidden = NO;
    self.netWorkLabel.hidden = NO;
    self.titleLabel.hidden = NO;
    self.retryBtn.hidden = YES;
    self.netWorkLabel.text = @"0KB/s";
}

- (void)showRetry:(BOOL)isError{
    self.hidden = NO;
    self.retryBtn.hidden = NO;
    self.indicatorView.hidden = YES;
    self.netWorkLabel.hidden = YES;
    self.titleLabel.hidden = YES;
    if (isError) {
        [self.retryBtn setTitle:@"视频播放失败，点击重试" forState:UIControlStateNormal];
    }else{
        [self.retryBtn setTitle:@"点击重新播放" forState:UIControlStateNormal];
    }
}

- (void)hide{
    self.hidden = YES;

}

- (void)clickRetry{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRetry)]) {
        [self.delegate clickRetry];
    }
}

@end
