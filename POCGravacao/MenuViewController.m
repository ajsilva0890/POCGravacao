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

@interface MenuViewController ()

@property (nonatomic) EntradaUsuario *tipoUsuario;
@property (nonatomic) NSMutableDictionary *bookShelf;
@property (nonatomic) NSString *bookKey;


@end

@implementation MenuViewController


- (IBAction)filho:(id)sender {
    
    [self.tipoUsuario setTipoDeUsuario:0 ];
    [self.navigationController pushViewController:_bookTemp  animated:YES];
    
}

- (IBAction)pai:(id)sender {
    
    [self.tipoUsuario setTipoDeUsuario:1 ];
    [self.navigationController pushViewController:_bookTemp  animated:YES];
    
}

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
    
    _bookShelf = [[NSMutableDictionary alloc] init];
    
    //[self createBook:14 bookName:@"3pq"];
    [self createBook:5 bookName:@"teste123"];
    [self createBook:100 bookName:@"lol"];
    [self createBook:14 bookName:@"3pq"];
    
    
//    for(_bookKey in _bookShelf){
//        [self bookForKey:_bookKey];
//    }
    
    
    
}

-(void) createBook:(NSInteger)bookTotalPages bookName:(NSString*)bookName{
    
    NSUUID *uuid = [[NSUUID alloc]init];
    NSString *key = [uuid UUIDString];
    
    self.bookTemp = [[BookViewController alloc] initWithPageTotal:bookTotalPages
                                                     bookName:bookName
                                                       bookID:key];
    [self setBook:_bookTemp forKey:key];
}

- (void)setBook:(BookViewController *)book forKey:(NSString *)key{
    self.bookShelf[key] = book;
}


- (BookViewController *)bookForKey:(NSString *)key{
    return self.bookShelf[key];
}


- (void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.bookShelf removeObjectForKey:key];
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
