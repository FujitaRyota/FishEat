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
    
    int x;
    int y;
    
    int score;
    int lvUP;
    
    int i;
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
        // センサーの更新間隔の指定
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0;
        
        // ハンドラを設定
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            speedX_ += data.acceleration.y;      // 横画面のため。xとyを入れ替える
            speedY_ -= data.acceleration.x;
            CGFloat posX = _myChara.center.x + speedX_;
            CGFloat posY = _myChara.center.y - speedY_;
            
            //NSLog(@"x:%f,y:%f", speedX_,speedY_);
            
            // 画面に表示
            self.xLabel.text = [NSString stringWithFormat:@"x: %0.5f", speedX_];
            self.yLabel.text = [NSString stringWithFormat:@"y: %0.5f", speedY_];
            
            // 自キャラと敵が重なり合ったか判定
            if (CGRectIntersectsRect(_myChara.frame, _enemy01.frame)) {
                i += 1;
                NSLog(@"捕食%d", i);
                x += 15;
                y += 5;
                
                score += 1;
                if (i / 5 == 1) {
                    lvUP += 1;
                    i = 0;
                }
                
                NSLog(@"NowLv.%d", lvUP);
                if (lvUP == 2) {
                    _myChara.image = [UIImage imageNamed:@"testball01.png"];
                }
                if (lvUP == 3) {
                    _myChara.image = [UIImage imageNamed:@"testball02.png"];
                }
                if (lvUP == 4) {
                    _myChara.image = [UIImage imageNamed:@"testball03.png"];
                }
                _enemy01.center = CGPointMake(x, y);
                
                NSLog(@"NowScore.%d", score);
            }
            
            //端にあたったら跳ね返る処理
            if (posX < 0.0) {
                posX = 0.0;
                
                //左の壁にあたったら0.25倍の力で跳ね返る
                speedX_ *= -0.25;
            } else if (posX > self.view.bounds.size.width) {
                posX = self.view.bounds.size.width;
                
                //右の壁にあたったら0.25倍の力で跳ね返る
                speedX_ *= -0.25;
            }
            if (posY < 0.0) {
                posY = 0.0;
                
                //上の壁にあたったら0.25倍の力で跳ね返る
                speedY_ = 0.25;
            } else if (posY > self.view.bounds.size.height) {
                posY = self.view.bounds.size.height;
                
                //下の壁にあたったら0.25倍の力で跳ね返る
                speedY_ *= -0.25;
            }
            _myChara.center = CGPointMake(posX, posY);
        };
        
        // 加速度の取得開始
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
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
