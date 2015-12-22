//
//  SEManager.m
//  FishEat
//
//  Created by FujitaRyota on 2015/12/03.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import "SEManager.h"

@implementation SEManager

static SEManager *sharedData_ = nil;


+ (SEManager *)sharedManager{
    @synchronized(self){
        if (!sharedData_) {
            sharedData_ = [[SEManager alloc]init];
        }
    }
    return sharedData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        soundArray = [[NSMutableArray alloc] init];
        _soundVolume = 1.0;
    }
    return self;
}

- (void)playSound:(NSString *)soundName{
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:soundName];
    NSURL *urlOfSound = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:0];
    player.volume = _soundVolume;
    player.delegate = (id)self;
    [soundArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [soundArray removeObject:player];
}

- (void)allStopAudio{
    for (NSInteger i=[soundArray count]-1; i >= 0; i--) {
        AVAudioPlayer* player = [soundArray objectAtIndex:i];
        [player stop];
        [soundArray removeObjectAtIndex:i];
        player = nil;
    }
}

@end