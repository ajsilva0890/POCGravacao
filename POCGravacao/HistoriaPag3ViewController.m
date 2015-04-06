//
//  HistoriaPag3ViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "HistoriaPag3ViewController.h"
#import "EntradaUsuario.h"

@interface HistoriaPag3ViewController (){
    
    AVAudioRecorder *_gravador3;
    AVAudioPlayer *_player3;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;


@end

@implementation HistoriaPag3ViewController

@synthesize pararButton3, playButton3, gravarPauseButton3;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        self.tabBarItem.title = @"Página 3";
    }
    
    return self;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_gravador3 successfully:(BOOL)flag{
    [gravarPauseButton3 setTitle:@"Gravar" forState:UIControlStateNormal];
    
    [pararButton3 setEnabled:NO];
    [playButton3 setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player2 successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Pagina 3"
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
    [pararButton3 setEnabled:NO];
    [playButton3 setEnabled:NO];
    
    //    definindo a arquivo de aúdio
    NSArray *pathComponents3 = [NSArray arrayWithObjects:
                                [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                @"MyAudioMemo3.m4a", nil ];
    
    NSURL *outputFileURL3 = [NSURL fileURLWithPathComponents:pathComponents3];
    
    //    definindo sessao de audio
    AVAudioSession *session3 = [[AVAudioSession alloc]init ];
    [session3 setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //    define a configuracao de gravador
    NSMutableDictionary *recordSettings3 = [[NSMutableDictionary alloc]init];
    
    [recordSettings3 setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings3 setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings3 setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //    iniciando e preparando a gravacao
    _gravador3 = [[AVAudioRecorder alloc] initWithURL:outputFileURL3 settings:recordSettings3 error:nil];
    _gravador3.delegate  = self;
    _gravador3.meteringEnabled = YES;
    [_gravador3 prepareToRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [pararButton3 setEnabled:NO];
        [gravarPauseButton3 setEnabled:NO];
    }
    else {
        [gravarPauseButton3 setEnabled:YES];
    }
}

- (IBAction)recordPauseTapped3:(id)sender {    //    para a reproducao do audio antes de comecar a gravar
    if (_player3.playing) {
        [_player3 stop];
    }
    
    if (!_gravador3.recording) {
        AVAudioSession *session2 = [[AVAudioSession alloc]init ];
        [session2 setActive:YES error:nil];
        
        //        comecar a gravacao
        NSTimeInterval time = 10.0;
        [_gravador3 recordForDuration:time];
        [gravarPauseButton3 setTitle:@"Pausar" forState:UIControlStateNormal];
        
    } else {
        
        [_gravador3 pause];
        [gravarPauseButton3 setTitle:@"Gravar" forState:UIControlStateNormal];
        
    }
    [pararButton3 setEnabled:YES];
    [playButton3 setEnabled:NO];
}

- (IBAction)stopTapped3:(id)sender {
    [_gravador3 stop];
    
    AVAudioSession *audioSession = [[AVAudioSession alloc]init ];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped3:(id)sender {
    if (!_gravador3.recording) {
        _player3 = [[AVAudioPlayer alloc] initWithContentsOfURL:_gravador3.url error:nil];
        [_player3 setDelegate:self];
        [_player3 setVolume:5];
        [_player3 play];
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
