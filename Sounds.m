//
//  Sounds.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 23/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//  http://www.freesfx.co.uk

#import "Sounds.h"
#import <AVFoundation/AVFoundation.h>

@interface Sounds ()

{
    AVAudioPlayer *click;
    AVAudioPlayer *background;
}

@end

@implementation Sounds

- (void) playClique:(int)select{
    
    NSString *path;
    NSURL *soundUrl;
    
    switch (select) {
        case 0:
            path = [NSString stringWithFormat:@"%@/clickButton.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 1:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 2:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 3:
            path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 4:
            path = [NSString stringWithFormat:@"%@/pageProx.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 5:
            path = [NSString stringWithFormat:@"%@/finalizar.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 6:
            path = [NSString stringWithFormat:@"%@/caixaLapis.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 7:
            path = [NSString stringWithFormat:@"%@/clickLapisEspessura.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
        case 8:
            path = [NSString stringWithFormat:@"%@/page.mp3", [[NSBundle mainBundle] resourcePath]];
            break;
    }
    
    soundUrl = [NSURL fileURLWithPath:path];
    click = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    click.numberOfLoops = 0;
    [click setVolume:0.1];
    [click play];
}

@end
