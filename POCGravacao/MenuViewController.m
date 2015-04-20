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
    
    
    for (int i = 0; i < 2; i++) {
        [self createBook:10 bookName:@"teste123"];
        [self createBook:10 bookName:@"lol"];
        [self createBook:14 bookName:@"3pq"];
    }
    
    
    _bookShelfButtons = [[NSMutableArray alloc] init];
    _viewContent = [[UIView alloc] initWithFrame:_scrollViewShelf.bounds];
    _imageViewShelf = [[UIImageView alloc] initWithFrame:_scrollViewShelf.bounds];
    
    [_scrollViewShelf addSubview:_imageViewShelf];
    [_scrollViewShelf addSubview:_viewContent];
    
    shelfTop = [UIImage imageNamed:@"shelfTop.png"];
    shelfMiddle = [UIImage imageNamed:@"shelfMiddle.png"];
    shelfBottom = [UIImage imageNamed:@"shelfBottom.png"];
    
    
    [self sortButtonArray];
    
}

-(void) viewDidLayoutSubviews{
    
    // Arruma tamanho e posição das labels de informação do livro.
    [_lblDescription sizeToFit];
    
    CGRect descBounds = _lblDescription.frame;
    CGSize authorSize = _lblAuthor.frame.size;
    
    [_lblAuthor setFrame:CGRectMake(descBounds.origin.x, descBounds.origin.y + descBounds.size.height + authorSize.height, authorSize.width, authorSize.height)];
    
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
    
    _lblTitle.text = [_bookSelected bookFantasyName];
    _lblDescription.text = [_bookSelected bookDescription];
    _lblAuthor.text = [_bookSelected bookAuthor];
    
    _imageViewCover.image = [UIImage imageNamed:[_bookSelected bookCoverURL]];
    
}

- (void) createBook:(NSInteger)bookTotalPages bookName:(NSString*)bookName{
    
    NSString *key = [NSString stringWithFormat:@"%lu", [BookShelf bookShelf].bookTotal];
    
    //NSLog(@"KEY >> %@", key);
    
    self.bookTemp = [[BookViewController alloc] initWithPageTotal:bookTotalPages
                                                         bookName:bookName
                                                          bookKey:key];
    
    [[BookShelf bookShelf] setBook:_bookTemp forKey:self.bookTemp.bookKey];
    
}

- (void) sortButtonArray{
    
    UIButton *btnBook;
    
    int tagCount = 0;
    int colunas = 3, w = 150, h = 150, marginX = 32, marginY = 32; // Configs dos botões de livro.
    unsigned long int bookTotal = [BookShelf bookShelf].bookTotal;
    unsigned long int linhas = bookTotal/3;
    
    
    CGSize shelfImageSize, auxSize;
    CGFloat shelfTopMaxHeight = 40, shelfMiddleMaxHeight = 150, shelfBottomMaxHeight = 200; // Tamanho maximo de altura de cada divisao.
    shelfImageSize.width = _imageViewShelf.frame.size.width; // Largura da scroll view. Não mude isso.
    shelfImageSize.height = shelfTopMaxHeight;
    _imageViewShelf.image = shelfTop;
    
    
    
    if (linhas % 3 != 0) {
        linhas++;
    }
    
    
    for(int i = 0; i <= linhas; i++){
        if (i > 3 || i == 0) {
            
            CGRect originalSize = _viewContent.bounds;
            CGRect newSize = CGRectMake(originalSize.origin.x, originalSize.origin.y, originalSize.size.width, originalSize.size.height + h);
            
            //[_viewContent setBackgroundColor:[UIColor redColor]];
            
            _scrollViewShelf.contentSize = CGSizeMake(newSize.size.width, newSize.size.height);
            [_viewContent setFrame:newSize];
            
        }
        
        // DESENHAR ESTANTE
        auxSize.height = shelfImageSize.height;
        shelfImageSize.height += shelfMiddleMaxHeight;
        
        //Se ultima linha, prepara desenho da divisao de baixo.
        if (i == linhas) {
            UIGraphicsBeginImageContext(CGSizeMake(shelfImageSize.width, shelfImageSize.height + shelfBottomMaxHeight));
        }
        else{
            UIGraphicsBeginImageContext(shelfImageSize);
        }
        
        
        // Copia a imagem atual para a tela de draw.
        [_imageViewShelf.image drawInRect:CGRectMake(0, 0, shelfImageSize.width, auxSize.height)];
        
        //Aplica a proxima imagem na tela de draw, logo abaixo a anterior.
        [shelfMiddle drawInRect:CGRectMake(0, auxSize.height, shelfImageSize.width, shelfMiddleMaxHeight)];
        
        
        if (i == linhas) {
            auxSize.height += shelfMiddleMaxHeight;
            [shelfBottom drawInRect:CGRectMake(0, auxSize.height, shelfImageSize.width, shelfBottomMaxHeight)];
        }
        
        //Atualiza a imagem.
        _imageViewShelf.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //Atualiza o tamanho da imagem.
        [_imageViewShelf setFrame:CGRectMake(_imageViewShelf.frame.origin.x, _imageViewShelf.frame.origin.y, shelfImageSize.width, shelfImageSize.height)];
        
        
        for (int j = 0; j < colunas && bookTotal > 0; j++) {
            bookTotal--;
            
            int spaceY = i*h+marginY;
            
            if (i > 0) {
                spaceY = i*h+(marginY);
            }
            
            btnBook = [[UIButton alloc] initWithFrame:CGRectMake(j*w+(marginX*j+marginX), spaceY, w-marginX, h-marginX)];
            
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
