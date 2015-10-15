//
//  ViewController.m
//  FishEat
//
//  Created by FujitaRyota on 2015/10/15.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    CMMotionManager* motionManager;
    CGAffineTransform moveTrans;

    double  xacBefore;
    double  yacBefore;
    double  zacBefore;

    double  xacNow;
    double  yacNow;
    double  zacNow;
    BOOL    Allocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Allocation = YES;
    
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
        motionManager.accelerometerUpdateInterval = 0.025f;
        
        // ハンドラを設定
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            // 加速度センサー
            if (Allocation == YES) {
                xacBefore = data.acceleration.x;
                yacBefore = data.acceleration.y;
                zacBefore = data.acceleration.z;
                Allocation = NO;
            } else if (Allocation == NO) {
                xacNow = 0.9 * xacBefore + 0.1 * xacNow;
                yacNow = 0.9 * yacBefore + 0.1 * yacNow;
                zacNow = 0.9 * zacBefore + 0.1 * zacNow;
                Allocation = YES;
            }
            // 画面に表示
            self.xLabel.text = [NSString stringWithFormat:@"x: %0.5f", xacNow];
            self.yLabel.text = [NSString stringWithFormat:@"y: %0.5f", yacNow];
            self.zLabel.text = [NSString stringWithFormat:@"z: %0.5f", zacNow];
            
            [self moveMyCharacter];
        };
        
        // 加速度の取得開始
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

// 自分のキャラクターを移動
- (void)moveMyCharacter{
    moveTrans = CGAffineTransformMakeTranslation(yacNow*500, xacNow*250);
    _myChara.transform = moveTrans;
}


@end
