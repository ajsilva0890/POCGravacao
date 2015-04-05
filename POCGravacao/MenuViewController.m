//
//  MenuViewController.m
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "MenuViewController.h"
#import "EntradaUsuario.h"

@interface MenuViewController ()

@property (nonatomic) EntradaUsuario *tipoUsuario;

@end

@implementation MenuViewController

@synthesize paiOuFilho;


- (IBAction)paiOuFilho:(id)sender {
    
    if(paiOuFilho.selectedSegmentIndex == 0) {
        [self.tipoUsuario setTipoDeUsuario:0 ];
        printf("tipo usuario: %d \n", [self.tipoUsuario tipoDeUsuario]);
    }
    
    if(paiOuFilho.selectedSegmentIndex == 1) {
        [self.tipoUsuario setTipoDeUsuario:1 ];
        printf("tipo usuario: %d \n", [self.tipoUsuario tipoDeUsuario]);
    }
}


- (IBAction)filho:(id)sender {
    
    [self.tipoUsuario setTipoDeUsuario:0 ];
    printf("tipo usuario: %d \n", [self.tipoUsuario tipoDeUsuario]);
    
}

- (IBAction)pai:(id)sender {

    [self.tipoUsuario setTipoDeUsuario:1 ];
    printf("tipo usuario: %d", [self.tipoUsuario tipoDeUsuario]);

}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        self.tabBarItem.title = @"Menu";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipoUsuario = [EntradaUsuario instance];
    // Do any additional setup after loading the view from its nib.
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
