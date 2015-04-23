//
//  SettingsViewController.h
//  POCGravacao
//
//  Created by Victor D. Savariego on 22/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic) IBOutlet UIScrollView *scrollViewHelpText;
@property (nonatomic) IBOutlet UIScrollView *scrollViewLog;

@property (nonatomic) IBOutlet UISwitch *switchBGMusic;

@property (nonatomic) IBOutlet UILabel *lblHelpText;
@property (nonatomic) IBOutlet UILabel *lblLog;


@end
