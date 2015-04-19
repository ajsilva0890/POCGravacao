//
//  PageViewController.h
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface PageViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
        
    float r, g, b, alpha;
    UIImage *imageGravar, *imagePausar, *imagePlay, *imageStop, *imageNarrar;
}

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) CGPoint location;
@property (nonatomic) UIImageView *drawImage;
@property (nonatomic) NSString *bookKey;

@property (weak, nonatomic) IBOutlet UIButton *btnRecordPause;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic) IBOutlet UIImageView *drawView;
@property (weak, nonatomic) IBOutlet UILabel *lblPage;


@property (nonatomic) unsigned int pageNumber;

@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

-(instancetype) initWithPageNumber:(NSInteger)pageNumber bookKey:(NSString*)bookKey;

- (void) stopPlayer;
- (void) setImagensButtonsFilho;
- (void) setImagensButtonsPai;

@end
