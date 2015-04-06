//
//  HistoriaPag2ViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "HistoriaPag2ViewController.h"
#import "EntradaUsuario.h"


@interface HistoriaPag2ViewController (){
    
    AVAudioRecorder *_gravador2;
    AVAudioPlayer *_player2;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;


@end

@implementation HistoriaPag2ViewController

@synthesize pararButton2, playButton2, gravarPauseButton2;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        self.tabBarItem.title = @"Página 2";
    }
    
    return self;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_gravador2 successfully:(BOOL)flag{
    [gravarPauseButton2 setTitle:@"Gravar" forState:UIControlStateNormal];
    
    [pararButton2 setEnabled:NO];
    [playButton2 setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player2 successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Pagina 2"
                                                    message: @"Acabou a gravação!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipoUsuario = [EntradaUsuario instance];
    
    //    desabilita botao play/stop quando iniciada a aplicaçao
    [pararButton2 setEnabled:NO];
    [playButton2 setEnabled:NO];
    
    //    definindo a arquivo de aúdio
    NSArray *pathComponents2 = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo2.m4a", nil ];
    
    NSURL *outputFileURL2 = [NSURL fileURLWithPathComponents:pathComponents2];
    
    //    definindo sessao de audio
    AVAudioSession *session2 = [[AVAudioSession alloc]init ];
    [session2 setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //    define a configuracao de gravador
    NSMutableDictionary *recordSettings2 = [[NSMutableDictionary alloc]init];
    
    [recordSettings2 setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings2 setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings2 setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //    iniciando e preparando a gravacao
    _gravador2 = [[AVAudioRecorder alloc] initWithURL:outputFileURL2 settings:recordSettings2 error:nil];
    _gravador2.delegate  = self;
    _gravador2.meteringEnabled = YES;
    [_gravador2 prepareToRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [pararButton2 setEnabled:NO];
        [gravarPauseButton2 setEnabled:NO];
    }
    else {
        [gravarPauseButton2 setEnabled:YES];
    }
}

- (IBAction)recordPauseTapped2:(id)sender {
    //    para a reproducao do audio antes de comecar a gravar
    if (_player2.playing) {
        [_player2 stop];
    }
    
    if (!_gravador2.recording) {
        AVAudioSession *session2 = [[AVAudioSession alloc]init ];
        [session2 setActive:YES error:nil];
        
        //        comecar a gravacao
        NSTimeInterval time = 10.0;
        [_gravador2 recordForDuration:time];
        [gravarPauseButton2 setTitle:@"Pausar" forState:UIControlStateNormal];
        
    } else {
        
        [_gravador2 pause];
        [gravarPauseButton2 setTitle:@"Gravar" forState:UIControlStateNormal];
        
    }
    [pararButton2 setEnabled:YES];
    [playButton2 setEnabled:NO];
}

- (IBAction)stopTapped2:(id)sender {
    [_gravador2 stop];
    
    AVAudioSession *audioSession = [[AVAudioSession alloc]init ];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped2:(id)sender {
    if (!_gravador2.recording) {
        _player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:_gravador2.url error:nil];
        [_player2 setDelegate:self];
        [_player2 setVolume:5];
        [_player2 play];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
