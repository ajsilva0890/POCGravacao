//
//  BookViewController.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "BookViewController.h"
#import "PageViewController.h"
#import "EntradaUsuario.h"
#import <AVFoundation/AVFoundation.h>

@interface BookViewController ()
{
    NSInteger corSelecionada, espessuraSelecionada;
    AVAudioPlayer *somHome, *somPageProx;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;
@property (weak, nonatomic) IBOutlet UIButton *btnActLequeCor;

@end

@implementation BookViewController

@synthesize btnDir, btnEsq, btnActLequeCor;


- (instancetype) initWithPageTotal:(NSInteger)pageTotal bookName:(NSString*)bookName bookKey:(NSString*)bookKey{
    
    self = [super init];
    
    if(self){
        _pageTotal = pageTotal;
        _bookName = bookName;
        _bookKey = bookKey;
        _pagesText = [[NSMutableArray alloc] init];
        [self getBookDescription];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipoUsuario = [EntradaUsuario instance];
    self.btnLequeCor = [[NSMutableArray alloc] init];
    self.btnLequeEspessura = [[NSMutableArray alloc] init];
    [btnEsq setHidden:YES];

    _pageIndex = 0;
    _pages = [[NSMutableArray alloc] init];
    
    [btnEsq setHidden:YES];
    

    for (unsigned int i=0; i<_pageTotal; i++) {
        PageViewController *page =[[PageViewController alloc] initWithPageNumber:i bookKey:_bookKey];
        [_pages addObject:page];
        [_viewPage addSubview:[page view]];
    }
    
    [self changePage];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:0] view]];
    

    [self somClickPageHome];
    [self createButtonsLeque];
    
}




- (void) somClickPageHome {
    NSString *path;
    NSURL *soundUrl;
    
    path = [NSString stringWithFormat:@"%@/home.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    somHome = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    somHome.numberOfLoops = 0;
    
    path = [NSString stringWithFormat:@"%@/pageProx.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    somPageProx = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    somPageProx.numberOfLoops = 0;
}

- (void) getBookDescription{
    
    _bookCoverURL = [NSString stringWithFormat:@"%@Cover", _bookName];
    
    NSString *descriptionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@TXT", _bookName]
                                                                ofType:@"txt"];
    
    NSString *descriptionContent = [NSString stringWithContentsOfFile:descriptionPath
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    
    int lineCount = 0;
    for (NSString *line in [descriptionContent componentsSeparatedByString:@"\n"]) {
        
        switch (lineCount) {
            case 0:
                _bookFantasyName = line;
                break;
            case 1:
                _bookDescription = line;
                break;
            case 2:
                _bookAuthor = line;
                break;
            case 3:
                if ([line isEqualToString:@"YES"]) {
                    _loadImagesForPages = YES;
                }
                else{
                    _loadImagesForPages = NO;
                }
                break;
            default:
                [_pagesText addObject:line];
                break;
        }
        
        
        lineCount++;
    }

}

- (void) atualizarUsuario {
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [[[_pages objectAtIndex:_pageIndex]btnStop]setEnabled:NO];
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:NO];
        [[_pages objectAtIndex:_pageIndex] setImagensButtonsFilho];
        [btnActLequeCor setHidden:NO];
        [btnActLequeCor setSelected:NO];
    }
    else {
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:YES];
        [[_pages objectAtIndex:_pageIndex] setImagensButtonsPai];
        [btnActLequeCor setHidden:YES];
        [btnActLequeCor setSelected:YES];
        
        for(UIButton *btnCor in self.btnLequeCor)
            [btnCor setHidden:YES];
        
        for(UIButton *btnEspessura in self.btnLequeEspessura)
            [btnEspessura setHidden:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [[self btnDir] setAlpha:0.2];
    [[self btnEsq] setAlpha:0.2];
    [self atualizarUsuario];
    
    [super viewWillAppear:YES];
}

- (IBAction)btnMenu:(id)sender{
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
    [somHome play];
    
}

- (IBAction)touchBtnEsq:(id)sender{
    if (_pageIndex <= 0 || [[_pages objectAtIndex:_pageIndex] recorder].recording){
        return;
    }
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];    
    [btnDir setHidden:NO];
    
    if (_pageIndex == 1) {
        [btnEsq setHidden:YES];
    }
    
    _pageIndex--;
    [self atualizarUsuario];
    [self changePage];
    [self corSelecionada:corSelecionada];
    [self espessuraSelecionada:espessuraSelecionada];
    [somPageProx play];
}

- (IBAction)touchBtnDir:(id)sender{
    if(_pageIndex >= _pageTotal-1 || [[_pages objectAtIndex:_pageIndex] recorder].recording){
        return;
    }
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];
    [btnEsq setHidden:NO];
    
    
    if (_pageIndex == _pageTotal-2) {
        [btnDir setHidden:YES];
    }

    _pageIndex++;
    [self atualizarUsuario];
    [self changePage];
    [self corSelecionada:corSelecionada];
    [self espessuraSelecionada:espessuraSelecionada];
    [somPageProx play];
}

- (void) changePage{
    //Change between pages, sets background of page or text.
    
    if (_loadImagesForPages) {
        _pageURL = [NSString stringWithFormat:@"Book%@Page%ld.png", _bookName, (long)_pageIndex];
        
    }
    else{
        _pageURL = @"Fundo.png";
        [[_pages objectAtIndex:_pageIndex] setPageText:[_pagesText objectAtIndex:_pageIndex]];
    }
    
    
    [[_pages objectAtIndex:_pageIndex] bgView].image = [UIImage imageNamed:_pageURL];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
    
}


- (void) createButtonsLeque {
    
    /*  Criacao dos botoes cor */
    int w = 50, h = 50, margin = 5, distancia = 15, qntdCor = 12, qntdEspessura = 3;
    
    UIButton *btnCor;
    
    for (int i = 0; i < qntdCor; i++) {
        
        btnCor = [[UIButton alloc] initWithFrame:CGRectMake(i*(w+distancia)+margin+w, self.view.frame.size.height - h - margin, w, h)];
        
        NSString *imageCor = [NSString stringWithFormat:@"cor%d.png", i];
        [btnCor setBackgroundImage:[UIImage imageNamed:imageCor]
                          forState:UIControlStateNormal];
        [btnCor setTag:i];
        [self.btnLequeCor addObject:btnCor];
    }
    
    for(UIButton *btnCor in self.btnLequeCor){
        [self.view addSubview:btnCor];
        [btnCor addTarget:self action:@selector(btnCor:) forControlEvents:UIControlEventTouchUpInside];
        [btnCor setHidden:YES];
    }
    
    /* criacao espessura */
    UIButton *btnEspessura;
    
    for (int i = 0; i < qntdEspessura; i++) {
        
        btnEspessura = [[UIButton alloc] initWithFrame:CGRectMake(margin, self.view.frame.size.height - i*(h+distancia)-margin-(2*h), w, h)];
        [btnEspessura setBackgroundImage:[UIImage imageNamed:@"Play.png"]
                                forState:UIControlStateNormal];
        [btnEspessura setTag:i];
        [self.btnLequeEspessura addObject:btnEspessura];
    }
    
    for(UIButton *btnEspessura in self.btnLequeEspessura){
        [self.view addSubview:btnEspessura];
        [btnEspessura addTarget:self action:@selector(btnEspessura:) forControlEvents:UIControlEventTouchUpInside];
        [btnEspessura setHidden:YES];
    }
    
    [self corSelecionada:INTMAX_MAX];
    [self espessuraSelecionada:INTMAX_MAX];
    
}


- (IBAction)btnActLequeCor:(id)sender{

    if (![btnActLequeCor isSelected]) {
        for(UIButton *btnCor in self.btnLequeCor){
            [btnCor setHidden:NO];
        }
        for(UIButton *btnEspessura in self.btnLequeEspessura){
            [btnEspessura setHidden:NO];
        }
        
        [btnActLequeCor setSelected:YES];
    }
    
    else{
        for(UIButton *btnCor in self.btnLequeCor){
            [btnCor setHidden:YES];
        }
        for(UIButton *btnEspessura in self.btnLequeEspessura){
            [btnEspessura setHidden:YES];
        }
        
        [btnActLequeCor setSelected:NO];
    }
}

- (void)btnCor:(id)sender{
    
    [self corSelecionada:[sender tag]];
    corSelecionada = [sender tag];
    
}

- (void)corSelecionada:(NSInteger)selecao {
    
    switch (selecao) {
        case 0: // vermelho
            [[_pages objectAtIndex:_pageIndex] setCores:193.0/255 G:25.0/255 B:55.0/255];
            break;
        case 1:// rosa
            [[_pages objectAtIndex:_pageIndex] setCores:191.0/255 G:39.0/255 B:135.0/255];
            break;
        case 2:// roxo
            [[_pages objectAtIndex:_pageIndex] setCores:101.0/255 G:55.0/255 B:137.0/255];
            break;
        case 3:// azul escuro
            [[_pages objectAtIndex:_pageIndex] setCores:43.0/255 G:61.0/255 B:141.0/255];
            break;
        case 4:// azul claro
            [[_pages objectAtIndex:_pageIndex] setCores:80.0/255 G:170.0/255 B:213.0/255];
            break;
        case 5:// verde claro
            [[_pages objectAtIndex:_pageIndex] setCores:52.0/255 G:158.0/255 B:141.0/255];
            break;
        case 6:// verde escuro
            [[_pages objectAtIndex:_pageIndex] setCores:84.0/255 G:159.0/255 B:72.0/255];
            break;
        case 7:// amarelo
            [[_pages objectAtIndex:_pageIndex] setCores:213.0/255 G:208.0/255 B:41.0/255];
            break;
        case 8:// laranja
            [[_pages objectAtIndex:_pageIndex] setCores:208.0/255 G:125.0/255 B:21.0/255];
            break;
        case 9: // branco
            [[_pages objectAtIndex:_pageIndex] setCores:1.0 G:1.0 B:1.0];
            break;
        case 10: // preto
            [[_pages objectAtIndex:_pageIndex] setCores:11.0/255 G:12.0/255 B:12.0/255];
            break;
        case 11:// cinza
            [[_pages objectAtIndex:_pageIndex] setCores:83.0/255 G:84.0/255 B:84.0/255];
            break;
        default:
            [[_pages objectAtIndex:_pageIndex] setCores:11.0/255 G:12.0/255 B:12.0/255];
            break;
    }
}


- (void)btnEspessura:(id)sender{
    
    [self espessuraSelecionada:[sender tag]];
    espessuraSelecionada = [sender tag];
}

- (void)espessuraSelecionada:(NSInteger)selecao {
    
    switch (selecao) {
        case 0:
            [[_pages objectAtIndex:_pageIndex] setEspessura:8];
            break;
        case 1:
            [[_pages objectAtIndex:_pageIndex] setEspessura:12];
            break;
        case 2:
            [[_pages objectAtIndex:_pageIndex] setEspessura:16];
            break;
        default:
            [[_pages objectAtIndex:_pageIndex] setEspessura:8];

            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
