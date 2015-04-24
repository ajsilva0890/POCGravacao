//
//  Sounds.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 23/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "Sounds.h"
#import <AVFoundation/AVFoundation.h>

@interface Sounds ()

{
    AVAudioPlayer *clickBook;
    AVAudioPlayer *clickPage;
    AVAudioPlayer *clickPageProx;
    AVAudioPlayer *clickHome;
    AVAudioPlayer *clickFinish;
    AVAudioPlayer *clickCaixaCor;
    AVAudioPlayer *clickNarrar;
    AVAudioPlayer *clickLer;
    
}

@property (nonatomic) NSMutableArray *allSounds;

@end

@implementation Sounds

- (void) playClique:(int)select{

    NSString *path;
    NSURL *soundUrl;
    
    switch (select) {
        case 0:
            path = [NSString stringWithFormat:@"%@/clickButton.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickBook = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickBook.numberOfLoops = 0;
            [clickBook play];
            break;
        case 1:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickHome = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickHome.numberOfLoops = 0;
            [clickHome play];
            break;
        case 2:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickNarrar = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickNarrar.numberOfLoops = 0;
            [clickNarrar play];
            break;
        case 3:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickLer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickLer.numberOfLoops = 0;
            [clickLer play];
            break;
        case 4:
            path = [NSString stringWithFormat:@"%@/pageProx.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickPageProx = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickPageProx.numberOfLoops = 0;
            [clickPageProx play];
            break;
        case 5:
            path = [NSString stringWithFormat:@"%@/finalizar.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickFinish = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickFinish.numberOfLoops = 0;
            [clickFinish play];
            break;
        case 6:
            path = [NSString stringWithFormat:@"%@/caixaLapis.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickCaixaCor = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickCaixaCor.numberOfLoops = 0;
            [clickCaixaCor play];
            break;
        case 7:
            path = [NSString stringWithFormat:@"%@/page.mp3", [[NSBundle mainBundle] resourcePath]];
            soundUrl = [NSURL fileURLWithPath:path];
            clickPage = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            clickPage.numberOfLoops = 0;
            [clickPage play];
            break;
    }
    
}


@end
