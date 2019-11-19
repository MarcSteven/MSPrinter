//
//  JPLTextArea.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/8/20.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "JPLTextArea.h"

@implementation JPLTextArea


/*
 * 设置文本区域的区域大小
 * x,y：文本区域的原点
 * width:文本区域的宽度
 * height:文本区域的高度
 */
-(BOOL) setArea:(int)x y:(int)y width:(int)width height:(int)height{

    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x7F];
    [self.printInfo.wrap addByte:(Byte) x];
    [self.printInfo.wrap addByte:(Byte) (x >> 8)];
    [self.printInfo.wrap addByte:(Byte) y];
    [self.printInfo.wrap addByte:(Byte) (y >> 8)];
    [self.printInfo.wrap addByte:(Byte) width];
    [self.printInfo.wrap addByte:(Byte) (width >> 8)];
    [self.printInfo.wrap addByte:(Byte) height];
    return [self.printInfo.wrap addByte:(Byte) (height >> 8)];
}


/*
 * 设置文本区域的字符间距和行间距
 * charSpace：字符间距
 * lineSpace：行间距
 */
-(BOOL) setSpace:(int)charSpace lineSpace:(int)lineSpace {
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x7E];
    [self.printInfo.wrap addByte:(Byte) charSpace];
    [self.printInfo.wrap addByte:(Byte) (charSpace >> 8)];
    [self.printInfo.wrap addByte:(Byte) lineSpace];
    return [self.printInfo.wrap addByte:(Byte) (lineSpace >> 8)];
}



/*
 * 从x,y坐标开始输出文本
 */
-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap addByte:(Byte)x];
    [self.printInfo.wrap addByte:(Byte)(x>>8)];
    [self.printInfo.wrap addByte:(Byte)y];
    [self.printInfo.wrap addByte:(Byte)(y>>8)];
    [self.printInfo.wrap add:text];
    return true;
}

/*
 * 根据对齐方式输出文本
 */
//public boolean drawOut(ALIGN align ,String text)	//page_textarea_text_by_align
-(BOOL)drawOut:(NSString*)text;
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x02];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap add:text];
    return true;
}

/*
 * 设置字体加粗效果
 */
-(BOOL)setFontBold:(BOOL) bold
{
    
    
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x7B];
    [self.printInfo.wrap addByte:(Byte)bold];
    return true;
    
}

/*
 * 设置字符放大效果
 */
-(BOOL)setFontEnlarge:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x76];
    [self.printInfo.wrap addByte:(Byte)enlargeX];
    [self.printInfo.wrap addByte:(Byte)enlargeY];
    return true;
}

/*
 * 设置文本区域字体
 * ascID:英文字体ID
 * hzID:汉字字体ID
 */
-(BOOL)setFont:(FONT_ID)ascID hzID:(FONT_ID)hzID
{
    
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x74];
    [self.printInfo.wrap addByte:0x7D];
    [self.printInfo.wrap addByte:(Byte)ascID];
    [self.printInfo.wrap addByte:(Byte)(ascID>>8)];
    [self.printInfo.wrap addByte:(Byte)hzID];
    [self.printInfo.wrap addByte:(Byte)(hzID>>8)];
    return true;
}



@end
