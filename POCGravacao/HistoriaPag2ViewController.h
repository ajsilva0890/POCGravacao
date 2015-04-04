//
//  HistoriaPag2ViewController.h
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HistoriaPag2ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *gravarPauseButton2;
@property (strong, nonatomic) IBOutlet UIButton *pararButton2;
@property (strong, nonatomic) IBOutlet UIButton *playButton2;

@end
