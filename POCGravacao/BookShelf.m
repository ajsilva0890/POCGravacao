//
//  BookShelf.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 16/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "BookShelf.h"


@interface BookShelf ()

@property (nonatomic, strong) NSMutableDictionary *bookShelf;

@end


@implementation BookShelf

+ (instancetype)bookShelf
{
    static BookShelf *bookShelf = nil;
    if (!bookShelf) {
        bookShelf = [[self alloc] initPrivate];
    }
    return bookShelf;
}

// No one should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BookShelf bookShelf]"
                                 userInfo:nil];
            return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _bookShelf = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setBook:(BookViewController *)book forKey:(NSString *)key{
    self.bookShelf[key] = book;
}


-(BookViewController *)bookForKey:(NSString *)key{
    return self.bookShelf[key];
}


-(void)deleteBookForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.bookShelf removeObjectForKey:key];
}
-(unsigned long) bookTotal{
    return [self.bookShelf count];
    
}


@end
