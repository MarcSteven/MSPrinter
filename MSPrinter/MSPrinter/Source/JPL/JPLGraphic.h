//
//  JPLGraphic.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/16.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLBase.h"
#import "PrinterInfo.h"


@interface JPLGraphic : JPLBase

typedef NS_ENUM(Byte, COLOR)
{
    White,
    Black,
};

-(BOOL)line:(int)startPointX startPointY:(int)startPointY endPointX:(int)endPointX endPointY:(int)endPointY width:(int)width;
-(BOOL)rect:(int)left top:(int)top right:(int)right bottom:(int)bottom width:(int)width color:(COLOR)color;
-(BOOL)rectFill:(int)left top:(int)top right:(int)right bottom:(int)bottom color:(COLOR)color;
-(BOOL)rect:(int)left top:(int)top right:(int)right bottom:(int)bottom;

@end
