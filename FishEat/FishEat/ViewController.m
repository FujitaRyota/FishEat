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
    
    long score;
    int lvUP;
    
    BOOL NoSound;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NoSound = NO;
    lvUP = 1;
    score = 0;
    
    // 自キャラの向きを反転
    _myChara.transform = CGAffineTransformScale(_myChara.transform, -1.0, 1.0);
    
    // ラベルのアニメーションを生成する（まだ開始しない）
    CABasicAnimation* blink = [CABasicAnimation animationWithKeyPath:@"opacity"];
    blink.duration = 1.95;
    blink.autoreverses = YES;
    blink.fromValue = @1.0;
    blink.toValue = @0.0;
    blink.repeatCount = HUGE_VALF;
    blink.fillMode = kCAFillModeBoth;
    blink.delegate = self;
    
    _blinkLayer = _scoreLabel.layer;
    _blinkAnimation = blink;
    
    [[SEManager sharedManager] playSound:@"bgm_01.mp3"];

    // CMMotionManagerのインスタンス生成
    motionManager = [[CMMotionManager alloc] init];
    [self setupAccelerometer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    // 今です！
    [_blinkLayer addAnimation:_blinkAnimation forKey:@"MyAnimation"];
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
            
            switch (lvUP) {
                case 1:
                    [self enemy01Move];
                    [self enemy01Collision];
                    break;
                    
                case 2:
                    _enemy02.hidden = NO;
                    _enemy02_a.hidden = NO;
                    _enemy02_b.hidden = NO;
                    _enemy02_c.hidden = NO;
                    [self enemy01Move];
                    [self enemy01Collision];
                    //[self enemy02Move];
                    //[self enemy02Collision];
                    break;
                
                case 3:
                    [self enemy01Move];
                    [self enemy01Collision];
/*
                    _enemy01.hidden = YES;
                    _enemy01_a.hidden = YES;
                    _enemy01_b.hidden = YES;
                    _enemy01_c.hidden = YES;
                    _enemy01_d.hidden = YES;
  */
                    [self enemy02Move];
                    [self enemy02Collision];
            
                     _enemy03.hidden = NO;
                     _enemy03_a.hidden = NO;
                     _enemy03_b.hidden = NO;
                     [self enemy03Move];
                     //[self enemy03Collision];
                    break;

                case 4:
                    /*
                    _enemy01.hidden = YES;
                    _enemy01_a.hidden = YES;
                    _enemy01_b.hidden = YES;
                    _enemy01_c.hidden = YES;
                    _enemy01_d.hidden = YES;
                    _enemy02.hidden = YES;
                    _enemy02_a.hidden = YES;
                    _enemy02_b.hidden = YES;
                    _enemy02_c.hidden = YES;
                    */
                    _enemy04.hidden = NO;
                    _enemy04_a.hidden = NO;
                    _enemy05.hidden = NO;
                    
                    [self enemy01Move];
                    [self enemy01Collision];
                    [self enemy02Move];
                    [self enemy02Collision];
                     [self enemy03Move];
                     //[self enemy03Collision];
                     [self enemy04Move];
                     //[self enemy04Collision];
                     [self enemy05Move];
                     //[self enemy05Collision];
                    
                    // ボスキャラの表示、移動、当たり判定
                    _enemy_boss.hidden = NO;
                    [self enemy_bossMove];
                    [self enemy_bossCollision];
                    break;
                    
                default:
                    break;
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
    if (score == 10) {
        lvUP = 2;
    } else if (score == 30) {
        lvUP = 3;
    } else if (score == 50) {
        lvUP = 4;
    }
 
    NSLog(@"Lv.%d", lvUP);
    if (lvUP == 2) {
        _myChara.image = [UIImage imageNamed:@"fish1.gif"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 100, 75);
    }
    if (lvUP == 3) {
        _myChara.image = [UIImage imageNamed:@"fish2.gif"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 150, 100);
    }
    if (lvUP == 4) {
        _myChara.image = [UIImage imageNamed:@"fish4.gif"];
        _myChara.frame = CGRectMake(_myChara.frame.origin.x, _myChara.frame.origin.y, 230, 150);
    }
    
    NSLog(@"Score.%ld", score);
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", score];
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

// 敵（Enemy02）の移動
- (void)enemy02Move{
    // _enemy02 の画像移動
    _enemy02.center = CGPointMake(_enemy02.center.x-2.5f, _enemy02.center.y);
    if (_enemy02.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy02.center = CGPointMake(850, y);
        _enemy02.hidden = NO;      // 画像を表示
    }
    
    // _enemy02_a の画像移動
    _enemy02_a.center = CGPointMake(_enemy02_a.center.x-1.7f, _enemy02_a.center.y);
    if (_enemy02_a.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy02_a.center = CGPointMake(850, y);
        _enemy02_a.hidden = NO;      // 画像を表示
    }
    
    // _enemy02_b の画像移動
    _enemy02_b.center = CGPointMake(_enemy02_b.center.x-1.5f, _enemy02_b.center.y);
    if (_enemy02_b.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy02_b.center = CGPointMake(850, y);
        _enemy02_b.hidden = NO;      // 画像を表示
    }
    
    // _enemy02_c の画像移動
    _enemy02_c.center = CGPointMake(_enemy02_c.center.x-2.2f, _enemy02_c.center.y);
    if (_enemy02_c.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy02_c.center = CGPointMake(850, y);
        _enemy02_c.hidden = NO;      // 画像を表示
    }
}

// 敵（Enemy03）の移動
- (void)enemy03Move{
    // _enemy03 の画像移動
    _enemy03.center = CGPointMake(_enemy03.center.x-2.5f, _enemy03.center.y);
    if (_enemy03.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy03.center = CGPointMake(900, y);
        _enemy03.hidden = NO;      // 画像を表示
    }
    
    // _enemy03_a の画像移動
    _enemy03_a.center = CGPointMake(_enemy03_a.center.x-1.7f, _enemy03_a.center.y);
    if (_enemy03_a.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy03_a.center = CGPointMake(900, y);
        _enemy03_a.hidden = NO;      // 画像を表示
    }
    
    // _enemy03_b の画像移動
    _enemy03_b.center = CGPointMake(_enemy03_b.center.x-1.5f, _enemy03_b.center.y);
    if (_enemy03_b.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy03_b.center = CGPointMake(900, y);
        _enemy03_b.hidden = NO;      // 画像を表示
    }
}

// 敵（Enemy04）の移動
- (void)enemy04Move{
    // _enemy04 の画像移動
    _enemy04.center = CGPointMake(_enemy04.center.x-2.5f, _enemy04.center.y);
    if (_enemy04.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy04.center = CGPointMake(900, y);
        _enemy04.hidden = NO;      // 画像を表示
    }
    
    // _enemy04_a の画像移動
    _enemy04_a.center = CGPointMake(_enemy04_a.center.x-1.7f, _enemy04_a.center.y);
    if (_enemy04_a.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy04_a.center = CGPointMake(900, y);
        _enemy04_a.hidden = NO;      // 画像を表示
    }
}

// 敵（Enemy05）の移動
- (void)enemy05Move{
    // _enemy05 の画像移動
    _enemy05.center = CGPointMake(_enemy05.center.x-2.5f, _enemy05.center.y);
    if (_enemy05.center.x <= -25) {
        y = random() % 380 + 1;
        _enemy05.center = CGPointMake(900, y);
        _enemy05.hidden = NO;      // 画像を表示
    }
}

- (void)enemy_bossMove {
    if (NoSound == NO) {
        [[SEManager sharedManager] playSound:@"bgm_boss2.mp3"];
        NoSound = YES;
    }
    // Enemy_Boss の画像移動
    _enemy_boss.center = CGPointMake(_enemy_boss.center.x-0.5f, _enemy_boss.center.y);
    if (_enemy_boss.center.x <= -2500) {
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
            [_blinkLayer addAnimation:_blinkAnimation forKey:@"MyAnimation"];
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


// 敵（Enemy02）の当たり判定
- (void)enemy02Collision{
    
    // 自キャラと敵が重なり合ったか判定 Enemy02
    if (CGRectIntersectsRect(_myChara.frame, _enemy02.frame)) {
        if (_enemy02.hidden == NO) {
            score += 1;
        }
        _enemy02.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy02_a
    if (CGRectIntersectsRect(_myChara.frame, _enemy02_a.frame)) {
        if (_enemy02_a.hidden == NO) {
            score += 1;
        }
        _enemy02_a.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy02_b
    if (CGRectIntersectsRect(_myChara.frame, _enemy02_b.frame)) {
        if (_enemy02_b.hidden == NO) {
            score += 1;
        }
        _enemy02_b.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
    
    // 自キャラと敵が重なり合ったか判定 _enemy02_c
    if (CGRectIntersectsRect(_myChara.frame, _enemy02_c.frame)) {
        if (_enemy02_c.hidden == NO) {
            score += 1;
        }
        _enemy02_c.hidden = YES;      // 画像を非表示
        [self LvUpMyChara];
    }
}

// あたったら確実に負けるボスキャラの移動とあたり判定
- (void)enemy_bossCollision{
    if (CGRectIntersectsRect(_myChara.frame, _enemy_boss.frame)) {
        [[SEManager sharedManager] playSound:@"gameover.mp3"];
        [motionManager stopAccelerometerUpdates];
        [self performSegueWithIdentifier:@"toGameOverView" sender:self];
    }
}
@end
