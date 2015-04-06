//
//  PageView.m
//  POCGravacao
//
//  Created by Victor D. Savariego on 6/4/15.
//  Copyright (c) 2015 Anderson José da Silva. All rights reserved.
//

#import "PageView.h"

@implementation PageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 20);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    //Começa o caminho de desenho.
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //Move para o ponto de desenho e adiciona linha entre o ultimo e atual ponto.
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 100, 100);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 300, 300);
    
    //Desenha o caminho.
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
     UIGraphicsEndImageContext();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Se x toques com a opção borracha ativa limpa a imagem.
    NSLog(@"UHUL");
    
    [super touchesBegan: touches withEvent: event];
    
}


@end
