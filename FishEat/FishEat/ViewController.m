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
            speedX_ += data.acceleration.y * 0.1;      // 横画面のため。xとyを入れ替える
            speedY_ -= data.acceleration.x * 0.1;
            CGFloat posX = _myChara.center.x + speedX_;
            CGFloat posY = _myChara.center.y - speedY_;
            
            //NSLog(@"x:%f,y:%f", speedX_,speedY_);
            
            // 画面に表示
            self.xLabel.text = [NSString stringWithFormat:@"x: %0.5f", speedX_];
            self.yLabel.text = [NSString stringWithFormat:@"y: %0.5f", speedY_];
            
            [self enemy01Move];
            [self enemy01Collision];
            if (lvUP == 4) {
                // ボスキャラの表示、移動、当たり判定
                _enemy_boss.hidden = NO;
                [self enemy_bossMove];
                [self enemy_bossCollision];
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
                speedY_ *= -0.25;
            } else if (posY > self.view.bounds.size.height) {
                posY = self.view.bounds.size.height;
                
                //下の壁にあたったら0.25倍の力で跳ね返る
                speedY_ *= -0.25;
            }
            _myChara.center = CGPointMake(posX, posY);
            /*
            if (speedX_ > 0.1f) {
                // 画像を反転
                _myChara.transform = CGAffineTransformScale(_myChara.transform, -1.0f, 1.0f);
            } else if (speedX_ < 0.1f){
                // 画像を反転
                _myChara.transform = CGAffineTransformScale(_myChara.transform, 1.0f, 1.0f);
            }
             */
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

// 進化
- (void)LvUpMyChara{
    if (score == 5) {
        lvUP = 2;
    } else if (score == 10) {
        lvUP = 3;
    } else if (score == 15) {
        lvUP = 4;
    }
 
    NSLog(@"Lv.%d", lvUP);
    if (lvUP == 2) {
        _myChara.image = [UIImage imageNamed:@"fish1.png"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 100, 75);
    }
    if (lvUP == 3) {
        _myChara.image = [UIImage imageNamed:@"fish2.png"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 150, 100);

    }
    if (lvUP == 4) {
        _myChara.image = [UIImage imageNamed:@"fish3.png"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 230, 150);
    }
    
    NSLog(@"Score.%d", score);
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", score];
}

// 敵（Enemy01）の移動
- (void)enemy01Move{
    // _enemy01 の画像移動
    _enemy01.center = CGPointMake(_enemy01.center.x-2.5f, _enemy01.center.y);
    if (_enemy01.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy01.center = CGPointMake(750, y);
        _enemy01.hidden = NO;      // 画像を表示
    }
    
    // _enemy01_a の画像移動
    _enemy01_a.center = CGPointMake(_enemy01_a.center.x-1.7f, _enemy01_a.center.y);
    if (_enemy01_a.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy01_a.center = CGPointMake(750, y);
        _enemy01_a.hidden = NO;      // 画像を表示
    }
    
    // _enemy01_b の画像移動
    _enemy01_b.center = CGPointMake(_enemy01_b.center.x-1.5f, _enemy01_b.center.y);
    if (_enemy01_b.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy01_b.center = CGPointMake(750, y);
        _enemy01_b.hidden = NO;      // 画像を表示
    }
    
    // _enemy01_c の画像移動
    _enemy01_c.center = CGPointMake(_enemy01_c.center.x-2.2f, _enemy01_c.center.y);
    if (_enemy01_c.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy01_c.center = CGPointMake(750, y);
        _enemy01_c.hidden = NO;      // 画像を表示
    }
    
    // _enemy01_d の画像移動
    _enemy01_d.center = CGPointMake(_enemy01_d.center.x-1.9f, _enemy01_d.center.y);
    if (_enemy01_d.center.x <= -25) {
        y = random() % 100 + 1;
        _enemy01_d.center = CGPointMake(750, y);
        _enemy01_d.hidden = NO;      // 画像を表示
    }
}

- (void)enemy_bossMove {
    // Enemy_Boss の画像移動
    _enemy_boss.center = CGPointMake(_enemy_boss.center.x-0.5f, _enemy_boss.center.y);
    if (_enemy_boss.center.x <= -100) {
        y = random() % 100 + 1;
        _enemy_boss.center = CGPointMake(850, y);
        
    }
}


// 敵（Enemy01）の当たり判定
- (void)enemy01Collision{
    
    // 自キャラと敵が重なり合ったか判定 Enemy01
    if (CGRectIntersectsRect(_myChara.frame, _enemy01.frame)) {
        if (_enemy01.hidden == NO) {
            score += 1;
        }
        _enemy01.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy01_a
    if (CGRectIntersectsRect(_myChara.frame, _enemy01_a.frame)) {
        if (_enemy01_a.hidden == NO) {
            score += 1;
        }
        _enemy01_a.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy01_b
    if (CGRectIntersectsRect(_myChara.frame, _enemy01_b.frame)) {
        if (_enemy01_b.hidden == NO) {
            score += 1;
        }
        _enemy01_b.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy01_c
    if (CGRectIntersectsRect(_myChara.frame, _enemy01_c.frame)) {
        if (_enemy01_c.hidden == NO) {
            score += 1;
        }
        _enemy01_c.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy01_d
    if (CGRectIntersectsRect(_myChara.frame, _enemy01_d.frame)) {
        if (_enemy01_d.hidden == NO) {
            score += 1;
        }
        _enemy01_d.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
}

// あたったら確実に負けるボスキャラの移動とあたり判定
- (void)enemy_bossCollision{
    if (CGRectIntersectsRect(_myChara.frame, _enemy_boss.frame)) {
        [motionManager stopAccelerometerUpdates];
        [self performSegueWithIdentifier:@"toGameOverView" sender:self];
    }
}
@end
