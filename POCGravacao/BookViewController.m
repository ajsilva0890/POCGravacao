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

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipoUsuario = [EntradaUsuario instance];
    
    _pageIndex = 0;
    _pages = [[NSMutableArray alloc] init];
    
    for (unsigned int i=0; i<_pageTotal; i++) {
        PageViewController *page =[[PageViewController alloc] initWithPageNumber:i];
        [_pages addObject:page];
        [_viewPage addSubview:[page view]];
    }
    
    [self changePage];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:0] view]];
    
}

- (instancetype) initWithPageTotal:(NSInteger)pageTotal bookName:(NSString*)bookName{
    
    self = [super init];
    
    if(self){
        _pageTotal = pageTotal;
        _bookName = bookName;
    }
    
    return self;
}

- (void) atualizarJogador {
    
    [[[_pages objectAtIndex:_pageIndex] player] pause];
    
    if ([self.tipoUsuario tipoDeUsuario] == 0) {
        [[[_pages objectAtIndex:_pageIndex]btnStop]setEnabled:NO];
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:NO];
        
    }
    else {
        [[[_pages objectAtIndex:_pageIndex]btnRecordPause]setEnabled:YES];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self atualizarJogador];
    [super viewWillAppear:YES];
    
}

- (IBAction)btnMenu:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)touchBtnEsq:(id)sender{
    
    if (_pageIndex <= 0 || [[_pages objectAtIndex:_pageIndex] recorder].recording){
        return;
    }
    
    _pageIndex--;
    [self atualizarJogador];
    [self changePage];
}

- (IBAction)touchBtnDir:(id)sender{
    
    if(_pageIndex >= _pageTotal-1 || [[_pages objectAtIndex:_pageIndex] recorder].recording){
        return;
    }
    
    _pageIndex++;
    [self atualizarJogador];
    [self changePage];
}

- (void)changePage{
    //Change between pages, sets background of page.
    
    _pageURL = [NSString stringWithFormat:@"Book%@Page%ld.png", _bookName, _pageIndex];
    
    [[_pages objectAtIndex:_pageIndex] bgView].image = [UIImage imageNamed:_pageURL];
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
    
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
