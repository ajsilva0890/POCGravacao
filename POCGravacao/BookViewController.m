//
//  BookViewController.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "BookViewController.h"
#import "PageViewController.h"
#import "PageView.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageIndex = 0;
    _pages = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_pageTotal; i++) {
        PageViewController *page =[[PageViewController alloc] initWithPageNumber:i];
        [_pages addObject:page];
        //NSLog(@"%@", [_pages objectAtIndex:i]);
    }
    
    [self.view ]
    PageView *teste = [[PageView alloc] init];
    [self.view bringSubviewToFront:teste];
    //[self.view sendSubviewToBack:[_pages objectAtIndex:0]];

}


-(instancetype) initWithPageTotal:(NSInteger)pageTotal{
    
    self = [super init];
    
    if(self){
        _pageTotal = pageTotal;
    }
    
    return self;
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
