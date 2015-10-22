//
//  ViewController.h
//  FishEat
//
//  Created by FujitaRyota on 2015/10/15.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController  {
@private
    UIAccelerationValue speedX_;
    UIAccelerationValue speedY_;
}

@property IBOutlet UILabel* xLabel;
@property IBOutlet UILabel* yLabel;
@property IBOutlet UIImageView* myChara;
@property IBOutlet UIImageView* enemy01;

@end

