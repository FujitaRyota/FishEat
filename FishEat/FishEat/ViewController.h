//
//  ViewController.h
//  FishEat
//
//  Created by FujitaRyota on 2015/10/15.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SEManager.h"

@interface ViewController : UIViewController  {
@private
    UIAccelerationValue speedX_;
    UIAccelerationValue speedY_;
    
    CALayer* _blinkLayer;
    CAAnimation* _blinkAnimation;
    
    //次の画面へ渡す引数
    NSInteger* _inheritScore;
}
@property (nonatomic) NSInteger* inheritScore;

@property IBOutlet UILabel* xLabel;
@property IBOutlet UILabel* yLabel;
@property IBOutlet UILabel* scoreLabel;
@property IBOutlet UIImageView* myChara;
@property IBOutlet UIImageView* enemy01;
@property IBOutlet UIImageView* enemy01_a;
@property IBOutlet UIImageView* enemy01_b;
@property IBOutlet UIImageView* enemy01_c;
@property IBOutlet UIImageView* enemy01_d;
@property IBOutlet UIImageView* enemy02;
@property IBOutlet UIImageView* enemy02_a;
@property IBOutlet UIImageView* enemy02_b;
@property IBOutlet UIImageView* enemy02_c;
@property IBOutlet UIImageView* enemy03;
@property IBOutlet UIImageView* enemy03_a;
@property IBOutlet UIImageView* enemy03_b;
@property IBOutlet UIImageView* enemy04;
@property IBOutlet UIImageView* enemy04_a;
@property IBOutlet UIImageView* enemy05;
@property IBOutlet UIImageView* enemy_boss;
@property IBOutlet UIImageView* backimage1;

@end

