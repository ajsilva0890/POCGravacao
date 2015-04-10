//
//  contadorAngle.m
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "EntradaUsuario.h"

@implementation EntradaUsuario

+ (instancetype) instance {
    
    static EntradaUsuario *auxiliar = nil;
    if (!auxiliar) {
        auxiliar = [[self alloc]initPrivite];
    }
    return auxiliar;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use  + [EntradaUsuario]"
                                 userInfo:nil ];
    
}

- (instancetype)initPrivite {
    
    self = [super init];
    if (self) {
        self.tipoDeUsuario = 0;
    }
    
    return self;
}


@end
