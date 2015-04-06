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


-(instancetype) initWithPageTotal:(NSInteger)pageTotal;

@end
