//
//  SettingsViewController.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 22/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "SettingsViewController.h"
#import "Sounds.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@property (nonatomic) Sounds *sons;
@property (nonatomic) AppDelegate *delegate;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _scrollViewHelpText.contentSize = _lblHelpText.frame.size;
    _scrollViewLog.contentSize = _lblLog.frame.size;
    
    self.sons = [[Sounds alloc] init];
    self.delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
}


-(IBAction)btnHome:(id)sender{
    [self.sons playClique:1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchBGMusic:(id)sender {
    
    if(self.switchBGMusic.on) {
        [self.delegate.background play];
    }
    else {
        [self.delegate.background stop];

    }
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
