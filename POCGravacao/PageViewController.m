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
    Boolean buscouAudio;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;

@end

@implementation PageViewController

@synthesize btnStop, btnPlay, btnRecordPause;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipoUsuario = [EntradaUsuario instance];
    buscouAudio = FALSE;
    
    imageIniciar = [UIImage imageNamed:@"Gravar.png"];
    imagePausar = [UIImage imageNamed:@"Pausar.png"];
    imagePlay = [UIImage imageNamed:@"Play.png"];
    imageStop = [UIImage imageNamed:@"Stop.png"];
    imageNarrar = [UIImage imageNamed:@"Narrar.png"];

    
    //    desabilita botao play/stop quando iniciada a aplicaçao
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];

    _lblPage.text = [NSString stringWithFormat:@"%i", _pageNumber+1];
    
//    [self loadAudioSettings];
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

    if ([self.tipoUsuario tipoDeUsuario] == 1) {
        return;
    }

    //Contexto da caixa de desenho.
    UIGraphicsBeginImageContext(_drawView.frame.size);
    [_drawImage.image drawInRect:_drawView.bounds];
    
    //Define a forma, tamanho e cor da linha.
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 12);
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

- (void)viewWillAppear:(BOOL)animated{
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [btnStop setEnabled:NO];
        [btnRecordPause setEnabled:NO];
    }
    else {
        [btnRecordPause setEnabled:YES];
    }
    [super viewWillAppear:YES];
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_record successfully:(BOOL)flag{
    
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    [btnRecordPause setEnabled:YES];
    [self btnPlayPauser];
    [btnRecordPause setBackgroundImage:imageIniciar forState:UIControlStateNormal];


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Terminou de Narrar"
                                                    message: @"Faça seu desenho e mude de página"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) btnGravarPausar {
    if ([btnRecordPause isSelected]) {
        [btnRecordPause setBackgroundImage:imageIniciar forState:UIControlStateNormal];
        [btnRecordPause setSelected:NO];
    }
    
    else{
        [btnRecordPause setBackgroundImage:imagePausar forState:UIControlStateNormal];
        [btnRecordPause setSelected:YES];
    }
}

- (void) btnPlayPauser {
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        if ([btnPlay isSelected]) {
            [btnPlay setBackgroundImage:imageNarrar forState:UIControlStateNormal];
            [btnPlay setSelected:NO];
        }
        
        else{
            [btnPlay setBackgroundImage:imageNarrar forState:UIControlStateNormal];
            [btnPlay setSelected:YES];
        }
    }
    else{
        if ([btnPlay isSelected]) {
            [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
            [btnPlay setSelected:NO];
        }
    
        else{
            [btnPlay setBackgroundImage:imagePausar forState:UIControlStateNormal];
            [btnPlay setSelected:YES];
        }
    }
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
        [self btnGravarPausar];
        
    } else {
        
        [_recorder pause];
        [self btnGravarPausar];
        
    }
    
    [btnStop setEnabled:YES];
    [btnPlay setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [_recorder stop];
    [btnRecordPause setBackgroundImage:imageIniciar forState:UIControlStateNormal];
    [btnRecordPause setSelected:NO];
    
    buscouAudio = FALSE;
    
    AVAudioSession *audioSession = [[AVAudioSession alloc]init ];
    [audioSession setActive:NO error:nil];
    
    }

- (IBAction)playTapped:(id)sender {
    
    if (!_player.playing) {
        if (!_recorder.recording && !buscouAudio) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
            NSString *namePathRecorer = [NSString stringWithFormat:@"RecorderPage%i", _pageNumber];
        
            temporaryRecFile = [prefs URLForKey:namePathRecorer];
        
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
            [_player setDelegate:self];
            [_player setVolume:10];
            
            buscouAudio = TRUE;
        }

        [btnRecordPause setEnabled:NO];
        [_player play];
    }
    else {
        [btnRecordPause setEnabled:YES];
        [btnRecordPause setBackgroundImage:imageIniciar forState:UIControlStateNormal];
        [_player pause];

    }

    [btnRecordPause setEnabled:YES];
    
    [self btnPlayPauser];
}

- (void) stopPlayer{
    [_player stop];
    [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
    [btnPlay setSelected:NO];
}

- (void) setImagensButtonsPai {
    [btnRecordPause setBackgroundImage:imageIniciar forState:UIControlStateNormal];
    [btnStop setBackgroundImage:imageStop forState:UIControlStateNormal];
    [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
    
    [btnStop setAlpha:1];
    [btnRecordPause setAlpha:1];
}

- (void) setImagensButtonsFilho {
    [btnPlay setBackgroundImage:imageNarrar forState:UIControlStateNormal];
    [btnStop setAlpha:0];
    [btnRecordPause setAlpha:0];
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
