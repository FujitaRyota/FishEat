//
//  SEManager.h
//  FishEat
//
//  Created by FujitaRyota on 2015/12/03.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import "AVFoundation/AVFoundation.h"
#import <Foundation/Foundation.h>

@interface SEManager : NSObject{
    NSMutableArray *soundArray;
}

@property(nonatomic) float soundVolume;

+ (SEManager *)sharedManager;
- (void)playSound:(NSString *)soundName;
- (void)allStopAudio;

@end
