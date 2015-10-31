# JYTVideoPlayerDemo

###本工程是对百度视频的一层简单封装（.a文件支持真机和模拟器，需要模拟器或真机单独包运行请去百度自行下载.a文件）。下载之后编译有错请替换.a文件，另附上网盘下载链接：http://pan.baidu.com/s/1mg6c8Vu

####1.创建播放器：

通过`JYTVideoController`类创建视频，注意百度视频只支持单实例，所以在创建其他实例之前需要确保调用stop方法停止视频。


    JYTVideoController * vc = [JYTVideoController 
                                videoControllerWithFrame:CGRectZero //播放器大小（zero会充满全屏幕） 
                                andVideoUrl:@"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8" //视频地址
                                andVideoType:DVideoTypeLesson //播放器显示类型
                                isShouldAutoPlay:YES //是否自动播放
                                isLandscape:YES];//是否横屏
                                

####2.设置背景图片

    /**设置背景图*/
    - (void)setBackgroundImage:(UIImage *)image;
    
####3.视频播放控制
    #pragma mark -视频控制
    #pragma mark 初始化视频
    - (void)initVideo;

    #pragma mark 暂停视频
    - (void)pauseVideo;

    #pragma mark 恢复播放
    - (void)playVideo;

    #pragma mark 停止播放
    - (void)stopVideo;

####4.视频播放事件监听（建议继承`JYTVideoController`创建一个子类，然后在子类中重写方法监听，并且需要调用`super`方法）
#####［1］按钮点按事件
    /**点击标题按钮*/
    - (void)clickTitleBtn;

    /**点赞*/
    - (void)clickStar;

    /*点击重新播放*/
    -(void)clickRetry;

    /**
     *  点击播放按钮
     *
     *  @param bar     播放工具条，isPlaying属性判断是暂停还是播放。
     *  @param playBtn 播放按钮
     */
    - (void)videoBottomBar:(JYTVideoBottomBar *)bar clickPlayBtn:(UIButton *)playBtn;

#####［2］进度条事件
    #pragma mark - 进度条控制
    /**拖动过程中*/
    - (void)onDragSlideValueChanged:(id)sender;
    /**拖动完毕*/
    - (void)onDragSlideDone:(id)sender;
    /**拖动开始*/
    - (void)onDragSlideStart:(id)sender;
    

#####［3］播放实时监听
    /**
     *  刷新进度方法
     *
     *  @param currentTime 播放到的时间（秒）
     *  @param allSecond   总时间
     */
    - (void)playTick:(int)currentTime totalDuration:(int)allSecond;

#####［4］缓冲监听
    /**开始缓冲*/
    - (void)startCache;
    /**结束缓冲*/
    - (void)endCache;



天天象上团队荣誉出品
http://www.daydays.com

联系邮箱：bihongbo@jiyoutang.com
          jiazhaoyang@jiyoutang.com

###欢迎大家issue我们！！
