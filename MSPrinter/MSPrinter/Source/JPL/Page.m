//
//  Page.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "Page.h"

@implementation Page

/*
 * 打印页面开始 使用打印机缺省参数绘制打印机页面 缺省页面宽576dots(72mm),高640dots（80mm）
 */
-(BOOL)start{
    self.printInfo.pageWidth = 576;
    self.printInfo.pageHeight = 640;
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x5B];
    return [self.printInfo.wrap addByte:0x00];
}

/*
 * 打印页面开始
 */
-(BOOL)start:(int)originX originY:(int)originY pageWidth:(int)pageWidth pageHeight:(int)pageHeight rotate:(PAGE_ROTATE)rotate
{
    if (originX < 0 || originX > 575)
    return false;
    if (originY < 0)
    return false;
    if (pageWidth < 0 || pageWidth > 576)
    return false;
    if (pageHeight < 0 )
    return false;
    self.printInfo.pageWidth = pageWidth;
    self.printInfo.pageHeight = pageHeight;
    if (!([self.printInfo.wrap addByte:0x1A]&&[self.printInfo.wrap addByte:0x5B]&&[self.printInfo.wrap addByte:0x01]))
    return false;
    if (![self.printInfo.wrap addShort:(short)originX])
    return false;
    if (![self.printInfo.wrap addShort:(short)originY])
    return false;
    if (![self.printInfo.wrap addShort:(short)pageWidth])
    return false;
    if (![self.printInfo.wrap addShort:(short)pageHeight])
    return false;
    return [self.printInfo.wrap addByte:(Byte)rotate];
}

/*
 * 绘制打印页面结束
 */
-(BOOL)end{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x5D];
    return [self.printInfo.wrap addByte:0x00];
}

/*
 * 打印页面内容 之前做的页面处理，只是把打印对象画到内存中，必须要通过这个方法把内容打印出来
 */
-(BOOL)print{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x4F];
    return [self.printInfo.wrap addByte:0x00];
}

/*
 * 当前页面重复打印几次
 */
-(BOOL)print:(int)count
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x4F];
    [self.printInfo.wrap addByte:0x01];
    return [self.printInfo.wrap addByte:(Byte)count];
}

@end
