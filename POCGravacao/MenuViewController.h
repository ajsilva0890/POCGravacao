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

@interface MenuViewController : UIViewController{
    
    UIImage *shelfTop, *shelfBottom, *shelfMiddle;
}

@property (nonatomic) BookViewController *bookTemp;
@property (nonatomic) BookViewController *bookSelected;
@property (nonatomic) NSMutableArray *bookShelfButtons;

@property (nonatomic) NSString *selectedBookButton;

@property (nonatomic) UIView *viewContent;

@property (nonatomic) IBOutlet UIScrollView *scrollViewShelf;

@property (nonatomic) UIImageView *imageViewShelf;
@property (nonatomic) IBOutlet UIImageView *imageViewCover;

@property (nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) IBOutlet UILabel *lblDescription;
@property (nonatomic) IBOutlet UILabel *lblAuthor;

@property (nonatomic) IBOutlet UIButton *btnFilho;
@property (nonatomic) IBOutlet UIButton *btnPai;

@end
