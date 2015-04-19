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
    Boolean buscouAudio, buscouGravacao;

}

@property (nonatomic) EntradaUsuario *tipoUsuario;

@end

@implementation PageViewController

@synthesize btnStop, btnPlay, btnRecordPause;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipoUsuario = [EntradaUsuario instance];
    buscouAudio = NO;
    buscouGravacao = NO;
    
    imageGravar = [UIImage imageNamed:@"Gravar.png"];
    imagePausar = [UIImage imageNamed:@"Pausar.png"];
    imagePlay = [UIImage imageNamed:@"Play.png"];
    imageStop = [UIImage imageNamed:@"Stop.png"];
    imageNarrar = [UIImage imageNamed:@"Narrar.png"];
    
    
    //Se for pai, libera botao de gravação.
    if ([self.tipoUsuario tipoDeUsuario] == 1) {
        [btnRecordPause setEnabled:YES];
    }
    
    [btnPlay setEnabled:YES];
    
    
    _lblPage.text = [NSString stringWithFormat:@"%i", _pageNumber+1];
    
    //    [self loadAudioSettings];
    [self loadImageSettings];
    
}

- (instancetype)initWithPageNumber:(NSInteger)pageNumber bookKey:(NSString*)bookKey{
    
    self = [super init];
    
    if (self){
        _pageNumber = (unsigned int)pageNumber;
        _bookKey = bookKey;
        
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
    
//    r = 0.0; g = 0.0; b = 0.0; alpha = 1.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
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
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.espessura);
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
    
    [super viewWillAppear:YES];
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)_record successfully:(BOOL)flag{
    
    [btnStop setEnabled:NO];
    [btnPlay setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    
    [btnRecordPause setEnabled:YES];
    [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
    
    [self playPauseConfig];
    
    
    
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Terminou de Narrar"
    //                                                    message: @"Faça seu desenho e mude de página"
    //                                                   delegate: nil
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil];
    //    [alert show];
}

- (void) recordPauseConfig {
    if (btnRecordPause.currentBackgroundImage == imageGravar) {
        [btnRecordPause setBackgroundImage:imagePausar forState:UIControlStateNormal];
    }
    
    else{
        [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
    }
}

- (void) playPauseConfig {
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        if (btnPlay.currentBackgroundImage == imageNarrar) {
            [btnPlay setBackgroundImage:imagePausar forState:UIControlStateNormal];
        }
        
        else{
            [btnPlay setBackgroundImage:imageNarrar forState:UIControlStateNormal];
        }
    }
    else{
        if (btnPlay.currentBackgroundImage == imagePlay) {
            [btnPlay setBackgroundImage:imagePausar forState:UIControlStateNormal];
        }
        
        else{
            [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
        }
    }
}

- (IBAction)recordPauseTapped:(id)sender {
    //    para a reproducao do audio antes de comecar a gravar
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        
        if (buscouGravacao == NO) {
            
            //    definindo a arquivo de aúdio
            NSArray *pathComponents = [NSArray arrayWithObjects:
                                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                       [NSString stringWithFormat:@"Book%@PageAudio%i.m4a", _bookKey, _pageNumber], nil ];
            
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
            
            NSString *namePathRecorer = [NSString stringWithFormat:@"RecorderBook%@Page%i", _bookKey, _pageNumber];
            
            [prefs setURL:outputFileURL forKey:namePathRecorer];
            [prefs synchronize];
            
            //    iniciando e preparando a gravacao
            _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:nil];
            _recorder.delegate  = self;
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            
            
            [session setActive:YES error:nil];
            buscouGravacao = YES;
            
        }
        
        //        Começar a gravacao
        NSTimeInterval time = 60.0; // Um minuto.
        [_recorder recordForDuration:time];
        [self recordPauseConfig];
        
        
    }
    else {
        
        [_recorder pause];
        [self recordPauseConfig];
        
    }
    
    [btnStop setEnabled:YES];
    [btnPlay setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [_recorder stop];
    
    [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
    [btnStop setEnabled:NO];
    
    buscouAudio = NO;
    buscouGravacao = NO;
    
    AVAudioSession *audioSession = [[AVAudioSession alloc] init];
    [audioSession setActive:NO error:nil];
    
}

- (IBAction)playTapped:(id)sender {
    
    if (!_player.playing) {
        if (!_recorder.recording && !buscouAudio) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSString *namePathRecorer = [NSString stringWithFormat:@"RecorderBook%@Page%i", _bookKey, _pageNumber];
            
            temporaryRecFile = [prefs URLForKey:namePathRecorer];
            
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
            [_player setDelegate:self];
            [_player setVolume:10];
            
            buscouAudio = YES;
        }
        
        [btnRecordPause setEnabled:NO];
        [_player play];
    }
    else {
        [btnRecordPause setEnabled:YES];
        [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
        [_player pause];
        
    }
    
    if (btnPlay.currentBackgroundImage == imagePausar) {
        [btnRecordPause setEnabled:YES];
    }
    
    [self playPauseConfig];
}

- (void) stopPlayer{
    [_player stop];
    [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
    [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
    
}

- (void) setImagensButtonsPai {
    [btnRecordPause setBackgroundImage:imageGravar forState:UIControlStateNormal];
    [btnStop setBackgroundImage:imageStop forState:UIControlStateNormal];
    [btnPlay setBackgroundImage:imagePlay forState:UIControlStateNormal];
    
    [btnStop setHidden:NO];
    [btnRecordPause setHidden:NO];
}

- (void) setImagensButtonsFilho {
    [btnPlay setBackgroundImage:imageNarrar forState:UIControlStateNormal];
    [btnStop setHidden:YES];
    [btnRecordPause setHidden:YES];
}

- (void) setEspesura:(NSInteger)p {
    
}

- (void) setCores:(float)R G:(float)G B:(float)B {
    
    r = R;
    g = G;
    b = B;
    alpha = 1.0;
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
