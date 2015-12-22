//
//  GameOverViewController.h
//  FishEat
//
//  Created by FujitaRyota on 2015/11/13.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Social/Social.h>

@interface GameOverViewController : UIViewController{
    NSInteger* _inheritScore;
}

@property (nonatomic) NSInteger* inheritScore;
@property IBOutlet UIButton* Continue;
@property IBOutlet UILabel* finishScore;

@end
