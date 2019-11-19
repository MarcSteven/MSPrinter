//
//  JPLBarcode.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/16.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "JPLBarcode.h"

@implementation JPLBarcode

/*
 *一维条码绘制
 */
-(BOOL)_1D_barcode:(int)x y:(int)y type:(BAR_1D_TYPE)type height:(int)height unit_width:(JPL_BAR_UNIT)unit_width rotate:(BAR_ROTATE)rotate text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x30];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addByte:(Byte)type];
    [self.printInfo.wrap addShort:(short)height];
    [self.printInfo.wrap addByte:(Byte)unit_width];
    [self.printInfo.wrap addByte:(Byte)rotate];
    return [self.printInfo.wrap add:text];
}
/*
 * code128
 */
-(BOOL)code128:(int)x y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width rotate:(BAR_ROTATE)rotate text:(NSString*)text
{
    return [self _1D_barcode:x y:y type:CODE128_AUTO height:bar_height unit_width:unit_width rotate:rotate text:text];
}
/*
 * Code128
 */
-(BOOL)code128:(ALIGN)align y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width roate:(BAR_ROTATE)rotate text:(NSString*)text
{
    int x = 0;
    Code128 *code128 =[[Code128 alloc]init];
//    Byte* buf = [code128 encode:text];
        if (code128.encode_data == nil)
        return false;
        if(![code128 decode:code128.encode_data length:code128.encode_data_size])
        return false;
    int bar_width = code128.encode_data_size;
    if (align ==CENTER)
    x=(self.printInfo.pageWidth-bar_width* unit_width)/2;
    else if(align ==RIGHT)
    x=self.printInfo.pageWidth-bar_width*unit_width;
    else
        x = 0;
    return [self _1D_barcode:x y:y type:CODE128_AUTO height:bar_height unit_width:unit_width rotate:rotate text:text];
}


-(BOOL)code128:(ALIGN)align startx:(int)startx endx:(int)endx y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width roate:(BAR_ROTATE)rotate text:(NSString*)text
{
    if(endx < startx)
    {
        int temp = startx;
        startx = endx;
        endx = temp;
    }
    int x = startx;
    int width = endx - startx;
    
    Code128 *code128 =[[Code128 alloc]init];
    //    Byte* buf = [code128 encode:text];
    code128.encode_data=[code128 encode:text];
    if (code128.encode_data == nil)
        return false;
    if(![code128 decode:code128.encode_data length:code128.encode_data_size])
        return false;
    int bar_width = code128.encode_data_size*unit_width;
    
    if(width < bar_width)
    {
        align = LEFT;
    }
    if (align ==CENTER)
//        x=(self.printInfo.pageWidth-bar_width* unit_width)/2;
    x = startx + (width - bar_width)/2;
    else if(align ==RIGHT)
//        x=self.printInfo.pageWidth-bar_width*unit_width;
    x=startx +width - bar_width;
//    else
//        x = 0;
    return [self _1D_barcode:x y:y type:CODE128_AUTO height:bar_height unit_width:unit_width rotate:rotate text:text];
}


/*
 * QRCode
 * int version:版本号，如果为0，将自动计算版本号。
 *             每个版本号容纳的字节数目是一定的。如果内容不足，将自动填充空白。通过定义一个大的版本号来固定QRCode大小。
 * int ecc：纠错方式,取值0, 1，2，3，纠错级别越高，有效字符越少，识别率越高。缺省为2
 * int unit_width：基本单元大小
 */
-(BOOL) QRCode:(int)x y:(int)y version:(int)version ecc:(QRCODE_ECC)ecc unit_width:(JPL_BAR_UNIT)unit_width rotate:(BAR_ROTATE)rotate text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x31];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addByte:(Byte)version];
    [self.printInfo.wrap addByte:(Byte)ecc];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addByte:(Byte)unit_width];
    [self.printInfo.wrap addByte:(Byte)rotate];
    return [self.printInfo.wrap add:text];
}
/*
 * PDF417
 */
-(BOOL)PDF417:(int)x y:(int)y col_num:(int)col_num ecc:(int)ecc LW_ratio:(int)LW_ratio unit_width:(JPL_BAR_UNIT)unit_width	rotate:(JPL_ROTATE)rotate text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x31];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap addByte:(Byte)col_num];
    [self.printInfo.wrap addByte:(Byte)ecc];
    [self.printInfo.wrap addByte:(Byte)LW_ratio];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addByte:(Byte)unit_width];
    [self.printInfo.wrap addByte:(Byte)rotate];
    return [self.printInfo.wrap add:text];
}

-(BOOL)DataMatrix:(int)x y:(int)y unit_width:(JPL_BAR_UNIT)unit_width rotate:(JPL_ROTATE)rotate text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x31];
    [self.printInfo.wrap addByte:0x02];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addByte:(Byte)unit_width];
    [self.printInfo.wrap addByte:(Byte)rotate];
    return [self.printInfo.wrap add:text];
}

-(BOOL)GridMatrix:(int)x y:(int)y ecc:(Byte)ecc unit_width:(JPL_BAR_UNIT)unit_width rotate:(JPL_ROTATE)rotate text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x31];
    [self.printInfo.wrap addByte:0x03];
    [self.printInfo.wrap addByte:(Byte)ecc];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addByte:(Byte)unit_width];
    [self.printInfo.wrap addByte:(Byte)rotate];
    return [self.printInfo.wrap add:text];
}

@end
