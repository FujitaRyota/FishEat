//
//  ViewController.h
//  FishEat
//
//  Created by FujitaRyota on 2015/10/15.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

//UIAccelerometerからの通知を受けるため UIAccelerometerDelegateプロトコルを実装
@interface ViewController : UIViewController <UIAccelerometerDelegate> {
@private
    UIImageView* imageView_;
    UIAccelerationValue speedX_;
    UIAccelerationValue speedY_;
}

@property IBOutlet UILabel* xLabel;
@property IBOutlet UILabel* yLabel;
@property IBOutlet UIImageView* myChara;

@end

