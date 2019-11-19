//
//  ESC.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "ESC.h"

@implementation ESC
@synthesize port;
@synthesize printInfo;
@synthesize text;
@synthesize image;
@synthesize barcode;
@synthesize grahic;

// 构造函数
-(id)init{
    self = [super init];
    if (self) {
        text=[[Text alloc]init];
        image = [[Image alloc] init];
        barcode = [[Barcode alloc]init];
        grahic = [[Graphic alloc]init];
    }
    return self;
}

//设置端口
- (void) setPort:(CBPeripheral *) value
{
    if (port == value)
    {
        return;
    }
    
    port = value;
    text.port = port;
    image.port = port;
    barcode.port = port;
    grahic.port = port;
}

//设置相关参数
-(void) setPrintInfo:(PrinterInfo *) value{
    if (printInfo == value)
    {
        return;
    }
    
    printInfo = value;
    text.printInfo = printInfo;
    image.printInfo = printInfo;
    barcode.printInfo = printInfo;
    grahic.printInfo = printInfo;
}


//唤醒打印机
-(BOOL)wakeUp{
    if(![self.printInfo.wrap addByte:0x00]) return FALSE;
    [NSThread sleepForTimeInterval:50];
    return [self restorePrinter];
}


//走纸n行
-(BOOL)feedLines:(int)lines{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x64];
    return [self.printInfo.wrap addByte:(Byte)lines];
}

//走纸n点
-(BOOL)feedDots:(int)dots{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x4A];
    return [self.printInfo.wrap addByte:(Byte)dots];
}

//获取打印机状态
-(BOOL)getPrinterStatue{
    [self.printInfo.wrap addByte:0x10];
    [self.printInfo.wrap addByte:0x04];
    return [self.printInfo.wrap addByte:0x05];
}

//-(BOOL)getPrinterStatue{
//    [self.printInfo.wrap addByte:0x1D];
//    [self.printInfo.wrap addByte:0x4A];
//    return [self.printInfo.wrap addByte:0x01];
//}

@end

