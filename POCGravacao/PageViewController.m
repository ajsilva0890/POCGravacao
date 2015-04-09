//
//  PageViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "PageViewController.h"
#import "EntradaUsuario.h"

@interface PageViewController ()
{
    NSURL *temporaryRecFile;
}


@property (nonatomic) EntradaUsuario *tipoUsuario;

@end


@implementation PageViewController

@synthesize btnStop, btnPlay, btnRecordPause;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipoUsuario = [EntradaUsuario instance];
    
    //    desabilita botao play/stop quando iniciada a aplicaçao
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];
    
    self.tabBarItem.title = [NSString stringWithFormat:@"Page %i", _pageNumber];
    _lblPage.text = [NSString stringWithFormat:@"%i", _pageNumber+1];
    
    
    
    
}


- (instancetype) initWithPageNumber:(NSInteger)pageNumber{
    
    self = [super init];
    
    if (self){
        _pageNumber = (unsigned int)pageNumber;
        
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    if ([self.tipoUsuario tipoDeUsuario] == 1) {
        [btnStop setEnabled:NO];
        [btnRecordPause setEnabled:NO];
    }
    else {
        [btnRecordPause setEnabled:YES];
    }
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_recorder successfully:(BOOL)flag{
    [btnRecordPause setTitle:@"Gravar" forState:UIControlStateNormal];
    
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Recorder"
                                                    message: @"Tocou tudo!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



- (IBAction)recordPauseTapped:(id)sender {
    //    para a reproducao do audio antes de comecar a gravar
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        //    definindo a arquivo de aúdio
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   [NSString stringWithFormat:@"PageAudio%i.m4a", _pageNumber], nil ];
        
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        //    definindo sessao de audio
        AVAudioSession *session = [[AVAudioSession alloc]init ];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        //    define a configuracao de gravador
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc]init];
        
        [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        //Salva o caminho da gravação
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *namePathRecorer = [NSString stringWithFormat:@"RecorderPage%i", _pageNumber];
        
        [prefs setURL:outputFileURL forKey:namePathRecorer];
        [prefs synchronize];

        
        //    iniciando e preparando a gravacao
        _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:nil];
        _recorder.delegate  = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        
        
        [session setActive:YES error:nil];
        
        //        comecar a gravacao
        NSTimeInterval time = 10.0;
        [_recorder recordForDuration:time];
        [btnRecordPause setTitle:@"Pausar" forState:UIControlStateNormal];
        
    } else {
        
        [_recorder pause];
        [btnRecordPause setTitle:@"Gravar" forState:UIControlStateNormal];
        
    }
    [btnStop setEnabled:YES];
    [btnPlay setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [_recorder stop];
    
    AVAudioSession *audioSession = [[AVAudioSession alloc]init ];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {
    if (!_recorder.recording) {
        
        //Carrega o caminho da gravação
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *namePathRecorer = [NSString stringWithFormat:@"RecorderPage%i", _pageNumber];
        
        temporaryRecFile = [prefs URLForKey:namePathRecorer];
        
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
        [_player setDelegate:self];
        [_player setVolume:10];
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
