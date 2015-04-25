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
#import "Sounds.h"

@interface BookViewController ()
{
    NSInteger corSelecionada, espessuraSelecionada;
    AVAudioPlayer *somHome, *somPageProx;
    CGRect posSelect, posUnselect;
}

@property (nonatomic) EntradaUsuario *tipoUsuario;

@property (nonatomic) Sounds *sons;

@end

@implementation BookViewController

@synthesize btnDir, btnEsq, btnActLequeCor, btnFinalizar, imageCheckViewAlert;


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
    self.sons = [[Sounds alloc] init];
    
    [btnEsq setHidden:YES];

    _pageIndex = 0;
    _pages = [[NSMutableArray alloc] init];
    
    [btnEsq setHidden:YES];
    [self.viewAlertFinalizar setHidden:YES];

    for (unsigned int i=0; i<_pageTotal; i++) {
        PageViewController *page =[[PageViewController alloc] initWithPageNumber:i bookKey:_bookKey];
        [_pages addObject:page];
        [_viewPage addSubview:[page view]];
    }
    
    [self changePage];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:0] view]];
    
    [self setBookLocked:NO];
    [btnFinalizar setHidden:YES];
    
    [self createButtonsLeque];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [[self btnDir] setAlpha:0.2];
    [[self btnEsq] setAlpha:0.2];
    [self atualizarUsuario];
    
    [super viewWillAppear:YES];
    
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
        [btnFinalizar setHidden:YES];
        [self.viewAlertFinalizar setHidden:YES];

    }
    else {
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:YES];
        [[_pages objectAtIndex:_pageIndex] setImagensButtonsPai];
        [btnActLequeCor setHidden:YES];
        
        for(UIButton *btnCor in self.btnLequeCor)
            [btnCor setHidden:YES];
        
        for(UIButton *btnEspessura in self.btnLequeEspessura)
            [btnEspessura setHidden:YES];
    }
}

- (IBAction)btnMenu:(id)sender{
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
    [self.sons playClique:1];
    
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
    [btnFinalizar setHidden:YES];
    [self.sons playClique:4];
    
}

- (IBAction)touchBtnDir:(id)sender{
    if(_pageIndex >= _pageTotal-1 || [[_pages objectAtIndex:_pageIndex] recorder].recording){
        return;
    }
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];
    [btnEsq setHidden:NO];
    
    
    if (_pageIndex == _pageTotal-2) {
        [btnFinalizar setHidden:NO];
        [btnDir setHidden:YES];
    }
    
    _pageIndex++;
    [self atualizarUsuario];
    [self changePage];
    [self corSelecionada:corSelecionada];
    [self espessuraSelecionada:espessuraSelecionada];
    [self.sons playClique:4];
}

- (IBAction)btnFinalizar:(id)sender{
    
    [self.sons playClique:5];
    [self.viewAlertFinalizar setHidden:NO];
    [imageCheckViewAlert setHidden:YES];
    
}

- (IBAction)btnFinalizarOk:(id)sender{
    
    [self.sons playClique:1];
    [imageCheckViewAlert setHidden:NO];
    [self setBookLocked:YES];
    [self performSelector:@selector(checkOn) withObject:nil afterDelay:0.5];
    
}

- (void) checkOn {
    
    [btnEsq setHidden:YES];
    [btnDir setHidden:NO];
    
    self.pageIndex = 0;
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
    
    [[_pages objectAtIndex:_pageIndex] stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
    [somHome play];

}

- (IBAction)btnFinalizarCancelar:(id)sender{
    [self.sons playClique:5];

    [self.viewAlertFinalizar setHidden:YES];
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
    int w = 65, h = 150, margin = 20, distancia = 10, qntdCor = 12, qntdEspessura = 3, wEs = 50, hEs = 50;
    
    UIButton *btnCor;
    
    for (int i = 0; i < qntdCor; i++) {
        
        btnCor = [[UIButton alloc] initWithFrame:CGRectMake(i*(w)+margin+w, self.view.frame.size.height - h/2 - margin + 25, w-20, h+20)];
        
        NSString *imageCor = [NSString stringWithFormat:@"c%d.png", i];
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
    
    posUnselect = btnCor.frame;
    posSelect = btnCor.frame;
    posSelect.origin.y -= 20;
    
    /* criacao espessura */
    UIButton *btnEspessura;
    
    for (int i = 0; i < qntdEspessura; i++) {
        
        btnEspessura = [[UIButton alloc] initWithFrame:CGRectMake(margin - 15, self.view.frame.size.height - i*(hEs+distancia)-margin-(2*hEs) + 20, wEs, hEs)];
        
        NSString *imageEspessura = [NSString stringWithFormat:@"espessura%d.png", i];
        
        [btnEspessura setBackgroundImage:[UIImage imageNamed:imageEspessura]
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
    
    [self.sons playClique:6];
    
    if (![btnActLequeCor isSelected]) {
        [[self btnActLequeCor] setAlpha:0.4];
        for(UIButton *btnCor in self.btnLequeCor){
            [btnCor setHidden:NO];
        }
        for(UIButton *btnEspessura in self.btnLequeEspessura){
            [btnEspessura setHidden:NO];
        }
        
        [btnActLequeCor setSelected:YES];
    }
    
    else{
        [[self btnActLequeCor] setAlpha:1];
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
    
    [self.sons playClique:7];
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
        case 9: // marrom
            [[_pages objectAtIndex:_pageIndex] setCores:84.0/255 G:48.0/255 B:19.0/255];
            break;
        case 10: // branco
            [[_pages objectAtIndex:_pageIndex] setCores:1.0 G:1.0 B:1.0];
            break;
        default: // preto
            [[_pages objectAtIndex:_pageIndex] setCores:11.0/255 G:12.0/255 B:12.0/255];
            break;
    }
}


- (void)btnEspessura:(id)sender{
    
    [self.sons playClique:7];
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
            [[_pages objectAtIndex:_pageIndex] setEspessura:18];
            break;
        default:
            [[_pages objectAtIndex:_pageIndex] setEspessura:12];

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
