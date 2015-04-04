//
//  HistoriaPag3ViewController.h
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HistoriaPag3ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *gravarPauseButton3;
@property (strong, nonatomic) IBOutlet UIButton *pararButton3;
@property (strong, nonatomic) IBOutlet UIButton *playButton3;

@end
