//
//  SettingsViewController.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 22/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _scrollViewHelpText.contentSize = _lblHelpText.frame.size;
    _scrollViewLog.contentSize = _lblLog.frame.size;
    
    
}


-(IBAction)btnHome:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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
