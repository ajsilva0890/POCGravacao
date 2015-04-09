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
    [btnPlay setEnabled:NO];

    _lblPage.text = [NSString stringWithFormat:@"%i", _pageNumber+1];
    
    [self loadAudioSettings];
    [self loadImageSettings];
}

- (instancetype)initWithPageNumber:(NSInteger)pageNumber{
    
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

-(void)loadImageSettings{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _drawImage.image = [defaults objectForKey:@"drawImageKey"];
    _drawImage = [[UIImageView alloc] initWithImage:nil];
    _drawImage.frame = _drawView.frame;
    [_drawView addSubview:_drawImage];
    
    r = 0.0; g = 0.0; b = 0.0; alpha = 1.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2 ) {
        _drawView.image = nil;
    }
    
    _currentPoint = [touch locationInView:touch.view];
    _lastPoint = [touch locationInView:_drawView];
    
    [self drawInViewCurrentPoint:_currentPoint lastPoint:_lastPoint];
    
    [super touchesBegan: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    _currentPoint = [touch locationInView:_drawView];
    
    [self drawInViewCurrentPoint:_currentPoint lastPoint:_lastPoint];
    
    _lastPoint = _currentPoint;
}

- (void) drawInViewCurrentPoint:(CGPoint)currentPoint lastPoint:(CGPoint)lastPoint{
    
    //Contexto da caixa de desenho.
    UIGraphicsBeginImageContext(_drawView.frame.size);
    [_drawImage.image drawInRect:_drawView.bounds];
    
    //Define a forma, tamanho e cor da linha.
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 18);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, alpha);
    
    // Altera o contexto de desenho.
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    
    //Começa o caminho de desenho.
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //Move para o ponto de desenho e adiciona linha entre o ultimo e atual ponto.
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    //Desenha o caminho.
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //Define o tamanho da caixa de desenho.
    [_drawImage setFrame:_drawView.bounds];
    
    _drawImage.alpha = 0.7;
    _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    [_drawView addSubview:_drawImage];
    //[self.view sendSubviewToBack:drawImage];

}

- (void)loadAudioSettings{
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
    
    //    iniciando e preparando a gravacao
    _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:nil];
    _recorder.delegate  = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
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
        AVAudioSession *session2 = [[AVAudioSession alloc]init ];
        [session2 setActive:YES error:nil];
        
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
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
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
