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

@interface BookViewController ()

@property (nonatomic) EntradaUsuario *tipoUsuario;
@property (weak, nonatomic) IBOutlet UIButton *btnActLequeCor;


@end

@implementation BookViewController

@synthesize btnDir, btnEsq, btnActLequeCor;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipoUsuario = [EntradaUsuario instance];
    self.btnLequeCor = [[NSMutableArray alloc] init];
    
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
    
    
    /*  Criacao dos botoes cor */
    int w = 50, h = 50, margin = 20;
    
    UIButton *btnCor;
    
    for (int i = 0; i < 9; i++) {
        
        btnCor = [[UIButton alloc] initWithFrame:CGRectMake(i*(w+20)+margin+w, self.view.frame.size.height - w - margin, w, h)];
        [btnCor setBackgroundImage:[UIImage imageNamed:@"Home.png"]
                          forState:UIControlStateNormal];
        [btnCor setTag:i];
        [self.btnLequeCor addObject:btnCor];
    }
    
    for(UIButton *btnCor in self.btnLequeCor){
        [self.view addSubview:btnCor];
        [btnCor addTarget:self action:@selector(btnCor:) forControlEvents:UIControlEventTouchUpInside];
        [btnCor setHidden:YES];
    }
    
}

- (instancetype) initWithPageTotal:(NSInteger)pageTotal bookName:(NSString*)bookName bookKey:(NSString*)bookKey{
    
    self = [super init];
    
    if(self){
        _pageTotal = pageTotal;
        _bookName = bookName;
        _bookKey = bookKey;
        [self getBookDescription];
    }
    
    return self;
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
            case 2:
                _bookAuthor = line;
            default:
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
    }
    else {
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:YES];
        [[_pages objectAtIndex:_pageIndex] setImagensButtonsPai];
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
}

- (void)changePage{
    //Change between pages, sets background of page.
    
    _pageURL = [NSString stringWithFormat:@"Book%@Page%ld.png", _bookName, (long)_pageIndex];
    
    [[_pages objectAtIndex:_pageIndex] bgView].image = [UIImage imageNamed:_pageURL];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
    
}


- (IBAction)btnActLequeCor:(id)sender{
    
    if (![btnActLequeCor isSelected]) {
        for(UIButton *btnCor in self.btnLequeCor){
            [btnCor setHidden:NO];
        }
        [btnActLequeCor setSelected:YES];
    }
    
    else{
        for(UIButton *btnCor in self.btnLequeCor){
            [btnCor setHidden:YES];
        }
        [btnActLequeCor setSelected:NO];
    }
}

-(void)btnCor:(id)sender{
    if ([sender tag] == 0) {
        //commands
    }
    
    else if ([sender tag] == 1) {
        //commands
    }
    
    else if ([sender tag] == 2) {
        //commands
    }
    
    else if ([sender tag] == 3) {
        //commands
    }
    
    else if ([sender tag] == 4) {
        //commands
    }
    else if ([sender tag] == 5) {
        //commands
    }
    
    else if ([sender tag] == 6) {
        //commands
    }
    
    else if ([sender tag] == 7) {
        //commands
    }
    
    else {
        //commands
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
