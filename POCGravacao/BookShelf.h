//
//  BookShelf.h
//  POCGravacao
//
//  Created by Victor D. Savariego on 16/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookViewController.h"

@interface BookShelf : NSObject

+ (instancetype)bookShelf;

- (void)setBook:(BookViewController*)book forKey:(NSString *)key;
- (BookViewController *)bookForKey:(NSString *)key;
- (void)deleteBookForKey:(NSString *)key;
- (unsigned long int) bookTotal;

@end

