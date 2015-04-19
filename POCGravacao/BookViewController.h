//
//  BookViewController.h
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookViewController : UIViewController

@property (nonatomic) NSMutableArray *pages;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger pageTotal;
@property (nonatomic) NSString* bookName;
@property (nonatomic) NSString* pageURL;
@property (nonatomic) NSString* bookKey;

@property (nonatomic) NSString* bookFantasyName;
@property (nonatomic) NSString* bookDescription;
@property (nonatomic) NSString* bookAuthor;
@property (nonatomic) NSString* bookCoverURL;


@property (nonatomic) NSMutableArray *btnLequeCor;
@property (nonatomic) NSMutableArray *btnLequeEspessura;


@property (weak, nonatomic) IBOutlet UIButton *btnEsq;
@property (weak, nonatomic) IBOutlet UIButton *btnDir;
@property (weak, nonatomic) IBOutlet UIView *viewPage;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

-(instancetype) initWithPageTotal:(NSInteger)pageTotal bookName:(NSString*)bookName bookKey:(NSString*)bookKey;

@end