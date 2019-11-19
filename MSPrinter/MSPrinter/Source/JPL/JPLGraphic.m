//
//  JPLGraphic.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/16.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//


#import "JPLGraphic.h"

@implementation JPLGraphic

-(BOOL)line:(int)startPointX startPiontY:(int)startPointY endPointX:(int)endPointX endPointY:(int)endPointY width:(int)width color:(COLOR)color
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x5C];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap addShort:(short)startPointX];
    [self.printInfo.wrap addShort:(short)startPointY];
    [self.printInfo.wrap addShort:(short)endPointX];
    [self.printInfo.wrap addShort:(short)endPointY];
    [self.printInfo.wrap addShort:width];
    return [self.printInfo.wrap addByte:(Byte)color];
}

-(BOOL)line:(int)startPointX startPointY:(int)startPointY endPointX:(int)endPointX endPointY:(int)endPointY width:(int)width
{
    return [self line:startPointX startPiontY:startPointY endPointX:endPointX endPointY:endPointY width:width color:Black];
}

-(BOOL)line:(int)startPointX startPointY:(int)startPointY endPointX:(int)endPointX endPointY:(int)endPointY
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x5C];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addShort:(short)startPointX];
    [self.printInfo.wrap addShort:(short)startPointY];
    [self.printInfo.wrap addShort:(short)endPointX];
    return [self.printInfo.wrap addShort:(short)endPointY];

}

-(BOOL)rect:(int)left top:(int)top right:(int)right bottom:(int)bottom
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x26];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addShort:(short)left];
    [self.printInfo.wrap addShort:(short)top];
    [self.printInfo.wrap addShort:(short)right];
    return [self.printInfo.wrap addShort:(short)bottom];
}


-(BOOL)rect:(int)left top:(int)top right:(int)right bottom:(int)bottom width:(int)width color:(COLOR)color
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x26];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap addShort:(short)left];
    [self.printInfo.wrap addShort:(short)top];
    [self.printInfo.wrap addShort:(short)right];
    [self.printInfo.wrap addShort:(short)bottom];
    return [self.printInfo.wrap addShort:(short)width];
}

-(BOOL)rectFill:(int)left top:(int)top right:(int)right bottom:(int)bottom color:(COLOR)color

{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x2A];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addShort:(short)left];
    [self.printInfo.wrap addShort:(short)top];
    [self.printInfo.wrap addShort:(short)right];
    [self.printInfo.wrap addShort:(short)bottom];
    return [self.printInfo.wrap addShort:(short)color];
}

@end
