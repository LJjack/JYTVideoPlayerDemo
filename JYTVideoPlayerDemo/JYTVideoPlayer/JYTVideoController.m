//
//  ViewController.m
//  JYTVideoPlayerDemo
//
//  Created by bihongbo on 15/10/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "JYTVideoController.h"
#import "CyberPlayerController.h"


@interface JYTVideoController ()



/**视频播放控制器*/
@property (nonatomic,strong) CyberPlayerController * cbPlayerVC;

/**底部工具条*/
@property (nonatomic,strong) JYTVideoBottomBar * bottomBar;

/**顶部工具条*/
@property (nonatomic,strong) JYTVideoTopBar * topBar;

/**中央提示框*/
@property (nonatomic,strong) JYTVideoLoadingView * centerView;

/**刷新UI计时器*/
@property (nonatomic,strong) NSTimer * videoTimer;

/**是否手动设置进度*/
@property (nonatomic,assign) BOOL isManualSeek;

@property (nonatomic,assign) NSInteger lastPlayDuration;

@end

@implementation JYTVideoController

+ (instancetype)videoControllerWithFrame:(CGRect)frame andVideoUrl:(NSString *)url andVideoType:(DVideoType)type isShouldAutoPlay:(BOOL)isShouldAutoPlay isLandscape:(BOOL)isLanscape{
    Class class = [self class];
    id vc = [[class alloc]init];
    [vc setFrame:frame];
    [vc setShouldAutoplay:isShouldAutoPlay];
    [vc setIsLandscape:isLanscape];
    [vc setVideoType:type];
    [vc setVideoUrl:url];
    return vc;
}

- (void)setBackgroundImage:(UIImage *)image{
    self.cbPlayerView.image = image;
}

-(void)setVideoUrl:(NSString *)videoUrl{
    
    _videoUrl = videoUrl;
    if (_cbPlayerVC) {
        NSURL *url = [NSURL URLWithString:_videoUrl];
        if (!url)
        {
            url = [NSURL URLWithString:[_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        [_cbPlayerVC setContentURL:url];
    }
}

#pragma mark - lazy property
-(UIImageView *)cbPlayerView{
    if (!_cbPlayerView) {
        _cbPlayerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_cbPlayerView];
        _cbPlayerView.userInteractionEnabled = YES;
    }
    return _cbPlayerView;
}

-(JYTVideoBottomBar *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[JYTVideoBottomBar alloc] initWithFrame:CGRectMake(0, self.cbPlayerView.frame.size.height - 50, self.cbPlayerView.frame.size.width, 50)];
        _bottomBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [_bottomBar.videoSlider addTarget:self action:@selector(onDragSlideStart:) forControlEvents:UIControlEventTouchDown];
        [_bottomBar.videoSlider addTarget:self action:@selector(onDragSlideDone:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar.videoSlider addTarget:self action:@selector(onDragSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
        _bottomBar.delegate = self;
        [self.cbPlayerView addSubview:_bottomBar];
    }
    return _bottomBar;
}

-(JYTVideoTopBar *)topBar{
    if(self.videoType == DVideoTypeTeahcherExp)return nil;
    if (!_topBar) {
        _topBar = [[JYTVideoTopBar alloc] initWithFrame:CGRectMake(0, 0, self.cbPlayerView.frame.size.width, 50)];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
        [_topBar.backBtn addTarget:self action:@selector(clickTitleBtn) forControlEvents:UIControlEventTouchUpInside];
        [_topBar.starBtn addTarget:self action:@selector(clickStar) forControlEvents:UIControlEventTouchUpInside];
        [self.cbPlayerView addSubview:_topBar];
    }
    return _topBar;
}

- (JYTVideoLoadingView *)centerView{
    if (!_centerView) {
        _centerView = [[JYTVideoLoadingView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _centerView.center = self.cbPlayerView.center;
        _centerView.hidden = YES;
        _centerView.delegate = self;
        [self.cbPlayerView addSubview:_centerView];
    }
    return _centerView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.bottomBar.alpha) {
        [self showBar:YES];
    }else{
        [self hideBar];
    }
}

#pragma mark - topBar 点击事件
/**点击标题按钮*/
- (void)clickTitleBtn{
    [self.cbPlayerVC stop];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(self.presentationController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**点赞*/
- (void)clickStar{
    self.topBar.starBtn.selected = !self.topBar.starBtn.selected;
}

#pragma mark -工具条显示隐藏
- (void)showBar:(BOOL)isLoop{
    [self.cbPlayerView bringSubviewToFront:self.bottomBar];
    [self.cbPlayerView bringSubviewToFront:self.topBar];
    self.cbPlayerView.userInteractionEnabled = YES;
    self.bottomBar.userInteractionEnabled = YES;
    self.topBar.userInteractionEnabled = YES;
    [UIView animateWithDuration:.2 animations:^{
        self.bottomBar.alpha = 1;
        self.topBar.alpha = 1;
    } completion:^(BOOL finished){
        if(isLoop){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hideBarLoop) withObject:nil afterDelay:kAutoHideBarTime inModes:@[NSRunLoopCommonModes]];
        }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }];
}

- (void)hideBar{
    [UIView animateWithDuration:.2 animations:^{
        self.bottomBar.alpha = 0;
        self.topBar.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideBarLoop{
    [self hideBar];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideBarLoop) withObject:nil afterDelay:kAutoHideBarTime inModes:@[NSRunLoopCommonModes]];
}

- (CyberPlayerController *)cbPlayerVC{
    if (!_cbPlayerVC) {
        [self setUpBaiDuVideo];
    }
    return _cbPlayerVC;
}

#pragma mark - VIEWDIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    if(!CGRectIsEmpty(self.frame)){
        self.view.frame = self.frame;
    }
    else{
        self.frame = self.view.frame;
    }
    self.cbPlayerView.image = [UIImage imageNamed:@"movie_background"];
    [self showBar:YES];
    
    if(self.videoUrl && self.shouldAutoplay){
    [self startPlayback];
    [self.centerView showLoading];
    }
}

#pragma mark - 百度视频初始化
- (void)setUpBaiDuVideo
{
    //添加开发者信息
    [[CyberPlayerController class]setBAEAPIKey:msAK SecretKey:msSK];
    //当前只支持CyberPlayerController的单实例
    CyberPlayerController * cbPlayerController = [[CyberPlayerController alloc] init];
    cbPlayerController.scalingMode = CBPMovieScalingModeAspectFit;
    _cbPlayerVC = cbPlayerController;
    _cbPlayerVC.dolbyEnabled = YES;
    _cbPlayerVC.shouldAutoClearRender = NO;
    _cbPlayerVC.accurateSeeking = YES;
    [self.cbPlayerView addSubview:cbPlayerController.view];
    NSURL *url = [NSURL URLWithString:self.videoUrl];
    if (!url)
    {
        url = [NSURL URLWithString:[self.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [_cbPlayerVC setContentURL:url];
    
    //初始化完成后直接播放视频，不需要调用play方法
    _cbPlayerVC.shouldAutoplay = YES;
    
    //注册监听，当播放器完成视频的初始化后会发送CyberPlayerLoadDidPreparedNotification通知，
    //此时naturalSize/videoHeight/videoWidth/duration等属性有效。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onpreparedListener:)
                                                 name: CyberPlayerLoadDidPreparedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startCaching:)
                                                 name: CyberPlayerStartCachingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goCaching:)
                                                 name: CyberPlayerGotCachePercentNotification
                                               object:nil];
    //注册监听，当播放器完成视频播放位置调整后会发送CyberPlayerSeekingDidFinishNotification通知，
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seekComplete:)
                                                 name:CyberPlayerSeekingDidFinishNotification
                                               object:nil];
    //注册网速监听，在播放器播放过程中，每秒发送实时网速(单位：bps）CyberPlayerGotNetworkBitrateKbNotification通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNetworkStatus:)
                                                 name:CyberPlayerGotNetworkBitrateNotification
                                               object:nil];
    //播放状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:CyberPlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackError) name:CyberPlayerPlaybackErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark - 进度条控制
- (void)onDragSlideValueChanged:(id)sender {
    UISlider * s = sender;
    NSLog(@"slide changing, %f", s.value);
    [self refreshProgress:s.value totalDuration:self.cbPlayerVC.duration isDrag:YES];
}

- (void)onDragSlideDone:(id)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideBarLoop) withObject:nil afterDelay:kAutoHideBarTime inModes:@[NSRunLoopCommonModes]];
    UISlider * s = sender;
    float currentTIme = [s value];
    NSLog(@"seek to %f", currentTIme);
    NSTimeInterval ctime = currentTIme;
    self.cbPlayerVC.initialPlaybackTime = ctime;
    //实现视频播放位置切换
    [self.cbPlayerVC seekTo:ctime];
    self.isManualSeek = YES;
    
}
- (void)onDragSlideStart:(id)sender {
    [self stopTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 计时刷新UI
- (void)startTimer{
    //为了保证UI刷新在主线程中完成。
    [self performSelectorOnMainThread:@selector(startTimeroOnMainThread) withObject:nil waitUntilDone:NO];
}
- (void)startTimeroOnMainThread{
    if(self.videoTimer){
        [self stopTimer];
    }
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}
- (void)timerHandler:(NSTimer*)timer
{
    NSLog(@"playable:---%f",self.cbPlayerVC.playableDuration);
    [self refreshProgress:self.cbPlayerVC.currentPlaybackTime totalDuration:self.cbPlayerVC.duration isDrag:NO];
}
- (void)stopTimer{
    if ([self.videoTimer isValid])
    {
        [self.videoTimer invalidate];
    }
    self.videoTimer = nil;
}

- (void)playTick:(int)currentTime totalDuration:(int)allSecond{}

- (void)refreshProgress:(int) currentTime totalDuration:(int)allSecond isDrag:(BOOL)drag{
    self.bottomBar.videoSlider.subValue = self.cbPlayerVC.playableDuration;
    NSDictionary* dict = [[self class] convertSecond2HourMinuteSecond:currentTime];
    self.bottomBar.leftTimeLbl.text = [NSString stringWithFormat:@"%@:%@",dict[@"minute"],dict[@"second"]];
    //    currentProgress.text = strPlayedTime;
    if(!drag){
        self.bottomBar.videoSlider.value = currentTime;
        self.bottomBar.videoSlider.maximumValue = allSecond;
        [self playTick:currentTime totalDuration:allSecond];
    }
    NSDictionary* dictLeft = [[self class] convertSecond2HourMinuteSecond:allSecond];
    self.bottomBar.rightTimeLbl.text = [NSString stringWithFormat:@"%@:%@",dictLeft[@"minute"],dictLeft[@"second"]];
    //    NSString* strLeft = [self getTimeString:dictLeft prefix:@"-"];
    //    remainsProgress.text = strLeft;
    //    sliderProgress.value = currentTime;
    //    sliderProgress.maximumValue = allSecond;
    
}

- (NSString*)getTimeString:(NSDictionary*)dict prefix:(NSString*)prefix
{
    int hour = [[dict objectForKey:@"hour"] intValue];
    int minute = [[dict objectForKey:@"minute"] intValue];
    int second = [[dict objectForKey:@"second"] intValue];
    
    NSString* formatter = hour < 10 ? @"0%d" : @"%d";
    NSString* strHour = [NSString stringWithFormat:formatter, hour];
    
    formatter = minute < 10 ? @"0%d" : @"%d";
    NSString* strMinute = [NSString stringWithFormat:formatter, minute];
    
    formatter = second < 10 ? @"0%d" : @"%d";
    NSString* strSecond = [NSString stringWithFormat:formatter, second];
    
    return [NSString stringWithFormat:@"%@%@:%@:%@", prefix, strHour, strMinute, strSecond];
}

+ (NSDictionary*)convertSecond2HourMinuteSecond:(int)second
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    int minute = 0;
    
    minute = second / 60;
    second = second -  minute *  60;
    
    if(minute < 10)
    {
        [dict setObject:[NSString stringWithFormat:@"0%d",minute] forKey:@"minute"];
    }else{
        [dict setObject:[NSString stringWithFormat:@"%d",minute] forKey:@"minute"];
    }
    if(second < 10){
        [dict setObject:[NSString stringWithFormat:@"0%d",second] forKey:@"second"];
    }else{
        [dict setObject:[NSString stringWithFormat:@"%d",second] forKey:@"second"];
    }
    
    return dict;
}

#pragma mark - 视频通知方法
#pragma mark 播放出错
- (void) playbackError{
    [self.centerView showRetry:YES];
}
#pragma mark 播放完毕
- (void)playbackFinish:(NSNotification *)noti{
    
    if(self.cbPlayerVC.playbackState == CBPMoviePlaybackStateStopped){
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        self.bottomBar.isPlay = NO;
        [self.centerView showRetry:NO];
        [self showBar:NO];
    });
    }
}
#pragma mark 开始缓冲
- (void)startCaching:(NSNotification *)noti{
    if([noti.object integerValue] == 0){[self endCache];[self.centerView hide]; return;}
    [self startCache];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.centerView showLoading];
    });
}

- (void)startCache{}
- (void)endCache{}

#pragma mark 缓冲中
- (void)goCaching:(NSNotification *)noti{
//    NSLog(@"%@",noti);
    if ([noti.object integerValue] >= 100) {
        [self startTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.centerView hide];
        });
    }
}

#pragma mark 初始化完成
- (void)onpreparedListener:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.centerView hide];
        //将视频显示view添加到当前view中
        [self.cbPlayerVC.view setFrame:self.cbPlayerView.frame];
    });
    [self startTimer];
}

#pragma mark 调整视频播放位置后方法
- (void)seekComplete:(NSNotification*)noti{
}

#pragma mark 网速回调
- (void) showNetworkStatus: (NSNotification*) aNotifycation
{
    
    int networkBitrateValue = [[aNotifycation object] intValue];
    NSLog(@"show network bitrate is %d\n", networkBitrateValue);
    int Kbit = 1024;
    int Mbit = 1024*1024;
    int networkBitrate = 0;
    if (networkBitrateValue > Mbit){
        networkBitrate = networkBitrateValue/Mbit;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } else if (networkBitrateValue > Kbit){
        networkBitrate = networkBitrateValue/Kbit;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerView.netWorkLabel.text = [NSString stringWithFormat:@"%dKB/s",networkBitrate];
        });
    } else {
        networkBitrate = networkBitrateValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
}

#pragma mark - centerview delegate
-(void)clickRetry{
    if(self.videoUrl){
    [self showBar:YES];
    self.cbPlayerVC.initialPlaybackTime = 0;
    [self startPlayback];
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 初始化视频
- (void)initVideo{
    //初始化视频文件
    [self.centerView showLoading];
    [self.cbPlayerVC start];
    self.bottomBar.isPlay = YES;
}

#pragma mark 暂停视频
- (void)pauseVideo{
    //如果当前正在播放视频时，暂停播放。
    self.bottomBar.isPlay = NO;
    [_cbPlayerVC pause];
    [self stopTimer];
}

#pragma mark 恢复播放
- (void)playVideo{
    if(self.videoUrl){
    self.bottomBar.isPlay = YES;
    //如果当前播放视频已经暂停，重新开始播放。
    [self.cbPlayerVC start];
    [self startTimer];
    }
    else{
        [self.centerView showRetry:YES];
    }
}

#pragma mark 停止播放
- (void)stopVideo{
    [self stopPlayback];
}


- (void)startPlayback{
    switch (self.cbPlayerVC.playbackState) {
        case CBPMoviePlaybackStateStopped:
            [self initVideo];
            break;
        case CBPMoviePlaybackStateInterrupted:
            [self stopVideo];
            [self.centerView showRetry:YES];
            break;
        case CBPMoviePlaybackStatePlaying:
            [self pauseVideo];
            break;
        case CBPMoviePlaybackStatePaused:
            [self playVideo];
            break;
        default:
            break;
    }
}

- (void)stopPlayback{
    //停止视频播放
    [_cbPlayerVC stop];
    //[mpPlayerController stop];
    [self stopTimer];
}

#pragma mark -bottomBar delegate
- (void)videoBottomBar:(JYTVideoBottomBar *)bar clickPlayBtn:(UIButton *)playBtn
{
    [self startPlayback];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)willResignActive
{
    if (_cbPlayerVC.playbackState == CBPMoviePlaybackStatePlaying) {
        self.lastPlayDuration = _cbPlayerVC.currentPlaybackTime;
        [self pauseVideo];
    }else{
        self.lastPlayDuration = 0;
    }
}
- (void)didBecomeActive

{
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if(self.isLandscape)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //设置横屏播放
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if(self.isLandscape)
        return YES;
    }
    
    return NO;
}

@end
