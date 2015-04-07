//
//  BookViewController.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "BookViewController.h"
#import "PageViewController.h"


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
        [_viewPage addSubview:[page view]];
        //NSLog(@"%@", [_pages objectAtIndex:i]);
    }
    
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:0] view]];
    
    //[self presentViewController:[_pages objectAtIndex:0] animated:YES completion:nil];
    
    // [self.view bringSubviewToFront:[[_pages objectAtIndex:0] view]];
    
    
    
}


-(instancetype) initWithPageTotal:(NSInteger)pageTotal{
    
    self = [super init];
    
    if(self){
        _pageTotal = pageTotal;
    }
    
    return self;
}

-(IBAction)touchBtnEsq:(id)sender{
    if (_pageIndex > 0) {
       _pageIndex--;
    }
    
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
}

-(IBAction)touchBtnDir:(id)sender{
    if(_pageIndex < _pageTotal-1){
        _pageIndex++;
    }
    
    [_viewPage bringSubviewToFront:[[_pages objectAtIndex:_pageIndex] view]];
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
