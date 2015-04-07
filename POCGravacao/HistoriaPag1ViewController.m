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

    NSURL *temporaryRecFile;
    
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
    [playButton setEnabled:YES];
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
        [gravarPauseButton setEnabled:YES];
    }
}

- (NSString *) dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
}

- (IBAction)recordPauseTapped:(id)sender {

    //    para a reproducao do audio antes de comecar a gravar
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_gravador.recording) {
        //    definindo a arquivo de aúdio
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                    @"MyAudioMemo.m4a", nil ];
        
        NSURL *outputFileURL2 = [NSURL fileURLWithPathComponents:pathComponents];
        
        //    definindo sessao de audio
        AVAudioSession *session2 = [[AVAudioSession alloc]init ];
        [session2 setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        //    define a configuracao de gravador
        NSMutableDictionary *recordSettings2 = [[NSMutableDictionary alloc]init];
        
        [recordSettings2 setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSettings2 setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSettings2 setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        //Salva o caminho da gravação
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        [prefs setURL:outputFileURL2 forKey:@"Test1"];
        [prefs synchronize];
        
        //    iniciando e preparando a gravacao
        _gravador = [[AVAudioRecorder alloc] initWithURL:outputFileURL2 settings:recordSettings2 error:nil];
        _gravador.delegate  = self;
        _gravador.meteringEnabled = YES;
        [_gravador prepareToRecord];
        
        
        [session2 setActive:YES error:nil];
        
        //        comecar a gravacao
        NSTimeInterval time = 10.0;
        [_gravador recordForDuration:time];
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
        
        //Carrega o caminho da gravação
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        temporaryRecFile = [prefs URLForKey:@"Test1"];
        
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
        [_player setDelegate:self];
        [_player setVolume:5];
        [_player play];

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
