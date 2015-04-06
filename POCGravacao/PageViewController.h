//
//  PageViewController.h
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PageViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnRecordPause;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (nonatomic) NSInteger pageNumber;

-(instancetype) initWithPageNumber:(NSInteger)pageNumber;

@end
