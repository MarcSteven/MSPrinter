//
//  PrinterInfo.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "PrinterInfo.h"

@implementation PrinterInfo
@synthesize escPageWidth;
@synthesize escPageHeight;
@synthesize cmdBufferSize;
@synthesize jplSupport;
@synthesize cpclSupport;
@synthesize pageWidth;
@synthesize pageHeight;
@synthesize model;
@synthesize wrap;


-(id) init{
    self = [super init];
    if (self) {
        model = NO_INIT;
        wrap = nil;
    }
    return  self;
}

-(void) setModel:(PRINTER_MODEL)value
{
    if (model == value) {
        return;
    }
    model = value;
    switch(model)
    {
        case VMP02:
            escPageWidth = 384;
            escPageHeight = 100;
            cmdBufferSize = 384*3-8;
            break;
        case VMP02_P:
            escPageWidth = 384;
            escPageHeight = 200;
            cmdBufferSize = 4096;
            break;
        case ULT113x:
            escPageWidth = 576;
            escPageHeight = 120;
            cmdBufferSize = 1024-8;
            break;
        case JLP351:
        case JLP351_IC:
            escPageWidth = 576;
            escPageHeight = 250;
            cmdBufferSize = 4096;
            jplSupport = true;
            break;
        case EXP341:
            escPageWidth = 576;
            escPageHeight = 250;
            cmdBufferSize = 4096;
            cpclSupport = true;
            break;
        default:
            break;
    }
}

@end
