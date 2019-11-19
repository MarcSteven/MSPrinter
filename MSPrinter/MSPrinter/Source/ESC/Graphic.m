//
//  Graphic.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/31.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "Graphic.h"

@implementation Graphic

-(BOOL)linedrawOut:(int)startPoint endPoint:(int)endPoint
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x27];
    [self.printInfo.wrap addByte:0x01];

    [self.printInfo.wrap  addShort:startPoint];
    return [self.printInfo.wrap  addShort:endPoint];
}


@end
