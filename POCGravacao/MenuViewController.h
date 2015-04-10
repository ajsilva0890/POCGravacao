//
//  MenuViewController.h
//  POCGravacao
//
//  Created by Anderson José da Silva on 04/04/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BookViewController.h"



@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *paiOuFilho;

@property(nonatomic, retain) IBOutlet UIButton *btnBook;

@property (nonatomic) BookViewController *book;

@end
