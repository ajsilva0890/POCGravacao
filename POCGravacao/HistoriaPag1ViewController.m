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
    [playButton setEnabled:NO];
    
    //    definindo sessao de audio
    AVAudioSession *session = [[AVAudioSession alloc]init ];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    [_gravador setDelegate:self];
    [super viewDidLoad];
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
        
        //Recording Settings
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
        [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
        
        NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath_ = [searchPaths objectAtIndex: 0];
        
        NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:[self dateString]];
        
        // File URL
        NSURL *url = [NSURL fileURLWithPath:pathToSave];
        
        //Save recording path to preferences
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        [prefs setURL:url forKey:@"Test1"];
        [prefs synchronize];
        
        AVAudioSession *session = [[AVAudioSession alloc]init ];
        [session setActive:YES error:nil];
        
        // Create recorder
        _gravador = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        [_gravador prepareToRecord];
        [_gravador record];
        
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
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        
        //Load recording path from preferences
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        temporaryRecFile = [prefs URLForKey:@"Test1"];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
        _player.delegate = self;
        [_player setNumberOfLoops:0];
        _player.volume = 5;
        [_player prepareToPlay];
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
