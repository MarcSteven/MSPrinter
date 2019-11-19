//
//  JPL.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "JPL.h"

@implementation JPL
@synthesize port;
@synthesize printInfo;
@synthesize text;
@synthesize page;
@synthesize image;
@synthesize barcode;
@synthesize grahic;
@synthesize textarea;

// 构造函数
-(id)init{
    self = [super init];
    if (self) {
        text=[[JPLText alloc]init];
        page=[[Page alloc]init];
        image=[[JPLImage alloc]init];
        barcode=[[JPLBarcode alloc]init];
        grahic = [[JPLGraphic alloc]init];
        textarea = [[JPLTextArea alloc]init];
    }
    return self;
}

//设置端口
-(void) setPort:(CBPeripheral *) value{
    if (port == value)
    {
        return;
    }
    
    port = value;
    text.port = port;
    page.port = port;
    image.port = port;
    barcode.port = port;
    grahic.port = port;
    textarea.port = port;
}

//设置相关参数
-(void) setPrintInfo:(PrinterInfo *) value{
    if (printInfo == value)
    {
        return;
    }
    printInfo = value;
    text.printInfo = printInfo;
    page.printInfo = printInfo;
    image.printInfo = printInfo;
    barcode.printInfo=printInfo;
    grahic.printInfo = printInfo;
    textarea.printInfo = printInfo;
}



/*
 * 走纸到下一张标签开始
 */
-(BOOL)feedNextLabelBegin
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x0C];
    return [self.printInfo.wrap addByte:0x00];
}

-(BOOL)feed:(FEED_TYPE)feed_type offset:(int)offset
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x0C];
    [self.printInfo.wrap addByte:(Byte)feed_type];
    return [self.printInfo.wrap addShort:(short)offset];
}
/*
 * 打印纸后退
 * 注意:1.需要打印机JLP351的固件版本3.0.0.0及以上
 *      2.需要设置软件设置打印机，使能FeedBack状态
 */
-(BOOL)feedBack:(int)dots
{
    return [self feed:BACK offset:dots];
}

-(BOOL)feedNextLabelEnd:(int)dots
{
    return [self feed:LABEL_END offset:dots];
}

-(BOOL)feedMarkOrGap:(int)dots
{
    return [self feed:MARK_OR_GAP offset:dots];
}

-(BOOL)feedMarkEnd:(int)dots
{
    return [self feed:MARK_END offset:dots];
}

-(BOOL)feedMarkBegin:(int)dots
{
    return [self feed:MARK_BEGIN offset:dots];
}

-(BOOL)gotoGPL
{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x23];
    return [self.printInfo.wrap addByte:0x00];
}




@end
