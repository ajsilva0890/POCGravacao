//
//  MenuViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "MenuViewController.h"
#import "EntradaUsuario.h"
#import "BookViewController.h"
#import "BookShelf.h"

@interface MenuViewController ()

@property (nonatomic) EntradaUsuario *tipoUsuario;
@property (nonatomic) NSString *bookKey;


@end

@implementation MenuViewController



- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        //commands
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tipoUsuario = [EntradaUsuario instance];
    
    //[self createBook:14 bookName:@"3pq"];
    
    for (int i = 0; i < 20; i++) {
        [self createBook:10 bookName:@"teste123"];
        [self createBook:10 bookName:@"lol"];
        [self createBook:100 bookName:@"3pq"];
    }


    _bookShelfButtons = [[NSMutableArray alloc] init];
    _viewContent = [[UIView alloc] initWithFrame:_scrollViewShelf.frame];
    
    [_scrollViewShelf addSubview:_viewContent];

    
    [self sortButtonArray];
    
    
    //    for(_bookKey in _bookShelf){
    //        [self bookForKey:_bookKey];
    //    }
    
    
}


- (IBAction) btnFilho:(id)sender {
    
    [self.tipoUsuario setTipoDeUsuario:0 ];
    [self.navigationController pushViewController:_bookSelected  animated:YES];
    
}

- (IBAction) btnPai:(id)sender {
    
    [self.tipoUsuario setTipoDeUsuario:1 ];
    [self.navigationController pushViewController:_bookSelected  animated:YES];
    
}

- (void) selectedButton:(id)sender{
    _selectedBookButton = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    _bookSelected = [[BookShelf bookShelf] bookForKey:_selectedBookButton];

}



- (void) createBook:(NSInteger)bookTotalPages bookName:(NSString*)bookName{
    
    NSString *key = [[NSString alloc] init];
    
    key = [NSString stringWithFormat:@"%lu", [BookShelf bookShelf].bookTotal];
    
    //NSLog(@"KEY >> %@", key);
    
    self.bookTemp = [[BookViewController alloc] initWithPageTotal:bookTotalPages
                                                         bookName:bookName
                                                          bookKey:key];
    
    [[BookShelf bookShelf] setBook:_bookTemp forKey:self.bookTemp.bookKey];
    
}


- (void) sortButtonArray{
    
    UIButton *btnBook;
    
    int tagCount = 0;
    int colunas = 3, w = 140, h = 140, margin = 30;
    unsigned long int bookTotal = [BookShelf bookShelf].bookTotal;
    unsigned long int linhas = bookTotal/3;
    
    if (linhas % 3 != 0) {
        linhas++;
    }
    
    
    for(int i = 0; i <= linhas; i++){
        if (i > 2 || i == 0) {
            
            CGRect originalSize = _viewContent.bounds;
            
            NSLog(@"%f, %f, %f, %f", originalSize.origin.x, originalSize.origin.y, originalSize.size.width, originalSize.size.height);
            
            CGRect newSize = CGRectMake(originalSize.origin.x, originalSize.origin.y, originalSize.size.width, originalSize.size.height + h);
            
            //[_viewContent setBackgroundColor:[UIColor redColor]];
            
            _scrollViewShelf.contentSize = CGSizeMake(newSize.size.width, newSize.size.height);
            [_viewContent setFrame:newSize];

        }
        
        for (int j = 0; j < colunas && bookTotal > 0; j++) {
            bookTotal--;
            btnBook = [[UIButton alloc] initWithFrame:CGRectMake(j*w+(margin*1.8), i*h+margin, w-margin, h-margin)];
            btnBook.tag = tagCount;
            
            tagCount++;
            
            //[btnBook setTitle:@"BUTTON" forState:UIControlStateNormal];
            [btnBook setBackgroundImage: [UIImage imageNamed:@"Home.png"]
                               forState:UIControlStateNormal];
            [self.bookShelfButtons addObject:btnBook];
        }

    }
    
    for(UIButton *btnBook in self.bookShelfButtons){
        [_viewContent addSubview:btnBook];
        [btnBook addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
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
