//
//  HistoriaPag1ViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "HistoriaPag1ViewController.h"
#import "EntradaUsuario.h"


@interface HistoriaPag1ViewController () {

    AVAudioRecorder *_gravador;
    AVAudioPlayer *_player;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;

@end

@implementation HistoriaPag1ViewController

@synthesize pararButton, playButton, gravarPauseButton;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        self.tabBarItem.title = @"Página 1";
    }
    
    return self;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_gravador successfully:(BOOL)flag{
    [gravarPauseButton setTitle:@"Gravar" forState:UIControlStateNormal];
    
    [pararButton setEnabled:NO];
    [playButton setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Pagina 1"
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
    [pararButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    //    definindo a arquivo de aúdio
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a", nil ];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    //    definindo sessao de audio
    AVAudioSession *session = [[AVAudioSession alloc]init ];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //    define a configuracao de gravador
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc]init];
    
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //    iniciando e preparando a gravacao
    _gravador = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:nil];
    _gravador.delegate  = self;
    _gravador.meteringEnabled = YES;
    [_gravador prepareToRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [pararButton setEnabled:NO];
        [gravarPauseButton setEnabled:NO];
    }
    else {
        [pararButton setEnabled:YES];
        [gravarPauseButton setEnabled:YES];
    }
}

- (IBAction)recordPauseTapped:(id)sender {

    //    para a reproducao do audio antes de comecar a gravar
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_gravador.recording) {
        AVAudioSession *session = [[AVAudioSession alloc]init ];
        [session setActive:YES error:nil];
        
        //        comecar a gravacao
        [_gravador record];
        [gravarPauseButton setTitle:@"Pausar" forState:UIControlStateNormal];
        
    } else {
        
        [_gravador pause];
        [gravarPauseButton setTitle:@"Gravar" forState:UIControlStateNormal];
        
    }
    [pararButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {

    [_gravador stop];
    
    AVAudioSession *audioSession = [[AVAudioSession alloc]init ];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {

    if (!_gravador.recording) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_gravador.url error:nil];
        [_player setDelegate:self];
        [_player play];
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
