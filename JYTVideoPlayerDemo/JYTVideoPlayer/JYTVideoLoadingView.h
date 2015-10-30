//
//  JYTVideoLoadingView.h
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/20.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYTVideoLoadingViewDelegate <NSObject>
@optional
- (void)clickRetry;

@end

@interface JYTVideoLoadingView : UIView

/**
 *  菊花
 */
@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

/**
 *  网速
 */
@property (nonatomic, strong) UILabel * netWorkLabel;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel * titleLabel;

/**
 *  重试按钮
 */
@property (nonatomic, strong) UIButton * retryBtn;

@property (nonatomic, weak) id<JYTVideoLoadingViewDelegate>  delegate;

- (void)showLoading;
- (void)showRetry:(BOOL)isError;
- (void)hide;

@end
