//
//  ViewController.m
//  FishEat
//
//  Created by FujitaRyota on 2015/10/15.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (CGFloat)lowpassFilter:(CGFloat)accel before:(CGFloat)before;
- (CGFloat)highpassFilter:(CGFloat)accel before:(CGFloat)before;
@end

@implementation ViewController {
    CMMotionManager* motionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // CMMotionManagerのインスタンス生成
    motionManager = [[CMMotionManager alloc] init];
    [self setupAccelerometer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAccelerometer {
    if (motionManager.accelerometerAvailable){
        // センサーの更新間隔の指定、10分の1で1Hz
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0;
        
        // ハンドラを設定
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            
        };
        
        // 加速度の取得開始
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //加速度センサーからの値取得開始
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1.0 / 60.0;
    accelerometer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    speedX_ = speedY_ = 0.0;
    
    //加速度センサーからの値取得終了
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
}

//加速度センサーからの通知
- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
    speedX_ += acceleration.y;      // 横画面のため。xとyを入れ替える
    speedY_ -= acceleration.x;
    CGFloat posX = _myChara.center.x + speedX_;
    CGFloat posY = _myChara.center.y - speedY_;
    
    NSLog(@"x:%f,y:%f", speedX_,speedY_);
    
    // 画面に表示
    self.xLabel.text = [NSString stringWithFormat:@"x: %0.5f", speedX_];
    self.yLabel.text = [NSString stringWithFormat:@"y: %0.5f", speedY_];
    
    //端にあたったら跳ね返る処理
    if (posX < 0.0) {
        posX = 0.0;
        
        //左の壁にあたったら0.4倍の力で跳ね返る
        speedX_ *= -0.4;
    } else if (posX > self.view.bounds.size.width) {
        posX = self.view.bounds.size.width;
        
        //右の壁にあたったら0.4倍の力で跳ね返る
        speedX_ *= -0.4;
    }
    if (posY < 0.0) {
        posY = 0.0;
        
        //上の壁にあたっても跳ね返らない
        speedY_ = 0.0;
    } else if (posY > self.view.bounds.size.height) {
        posY = self.view.bounds.size.height;
        
        //下の壁にあたったら1.5倍の力で跳ね返る
        speedY_ *= -0.4;
    }
    _myChara.center = CGPointMake(posX, posY);
}

//ローパスフィルタ
- (CGFloat)lowpassFilter:(CGFloat)accel before:(CGFloat)before
{
    static const CGFloat kFilteringFactor = 0.1;
    return (accel * kFilteringFactor) + (before * (1.0 - kFilteringFactor));
}

//ハイパスフィルタ
- (CGFloat)highpassFilter:(CGFloat)accel before:(CGFloat)before
{
    return (accel - [self lowpassFilter:accel before:before]);
}


@end
