//
//  ESCBase.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//
#import "PrinterType.h"
#import "ESCBase.h"

@implementation ESCBase
@synthesize port;
@synthesize printInfo;
@synthesize buffer;

-(id) init{
    self = [super init];
    port = nil;
    printInfo = nil;
    return self;
}

//设置打印对象的x，y坐标
//x坐标不能大于0x1FF和ESC页面宽度
//y坐标不能大于0x7F和ESC页面高度
- (BOOL) setXY:(int)x y:(int)y {
    if (x < 0 || x >= printInfo.escPageWidth || x > 0x1FF) {
        return FALSE;
    }
    
    if (y < 0 || y >= printInfo.escPageHeight || y > 0x7F) {
        return FALSE;
    }
    
    ushort pos = ((x & 0x1FF) | ((y & 0x7F) << 9));
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x24];
    return [self.printInfo.wrap addShort:pos];
}

//设置打印对象对齐方式
-(BOOL) setAlign:(ALIGN) align{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x61];
    return [self.printInfo.wrap addByte:(Byte)align];
}

//设置行间距
-(BOOL) setLineSpace:(int) dots{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x33];
    return [self.printInfo.wrap addByte:(Byte)dots];
}

//打印机恢复开机初始状态
-(BOOL) restorePrinter{
    [self.printInfo.wrap addByte:0x1B];
    return [self.printInfo.wrap addByte:0x40];
}

//换行回车
-(BOOL) feedEnter {
    [self.printInfo.wrap addByte:0x0D];
    return [self.printInfo.wrap addByte:0x0A];
}

@end
