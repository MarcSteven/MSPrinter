//
//  JPLText.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "JPLText.h"

@implementation JPLText

-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text
{
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x54];
    [self.printInfo.wrap addByte:0x00];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap add:text];
    return [self.printInfo.wrap addByte:0x00];

}
-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text fontHeight:(int)fontHeight bold:(Boolean)bold reverse:(Boolean)reverse underLine:(Boolean)underLine deletLine:(Boolean)deleteLine enlargeX:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY rotateAngle:(ROTATE)rotateAngle
{
    if(x<0 || y < 0)
    return false;
    if(x>=self.printInfo.pageWidth || y < 0)
    return false;
    

    int font_type = 0;
    if (bold)
    font_type |= 0x0001;
    if (underLine)
    font_type |= 0x0002;
    if (reverse)
    font_type |= 0x0004;
    if (deleteLine)
    font_type |= 0x0008;
    switch (rotateAngle)
    {
        case ROTATE_90:
        font_type |= 0x0010;
        break;
        case ROTATE_180:
        font_type |= 0x0020;
        break;
        case ROTATE_270:
        font_type |= 0x0030;
        break;
        default:
        break;
    }
    int ex = enlargeX;
    int ey = enlargeY;
    ex &= 0x000F;
    ey &= 0x000F;
    font_type |= (ex << 8);
    font_type |= (ey << 12);
    
    [self.printInfo.wrap addByte:0x1A];
    [self.printInfo.wrap addByte:0x54];
    [self.printInfo.wrap addByte:0x01];
    [self.printInfo.wrap addShort:(short)x];
    [self.printInfo.wrap addShort:(short)y];
    [self.printInfo.wrap addShort:(short)fontHeight];
    [self.printInfo.wrap addShort:(short)font_type];
    [self.printInfo.wrap add:text];
    return [self.printInfo.wrap addByte:0x00];
}

//-(BOOL)isChinese:(char)c
//{
//    Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
//    if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
//        || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
//        || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
//        || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
//        || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
//        || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {
//        return true;
//    }
//    return false;
//}

-(int)calcTextWidth:(int)font_width text:(NSString*)text
{
    int hz_count = 0;
    int ascii_count = 0;
    for(int i= 0;i < text.length;i++)
    {
//        if (isChinese(text.charAt(i)))
//        {
//            hz_count++;
//        }
//        else
        {
            ascii_count++;
        }
    }
    return (hz_count*font_width + ascii_count*font_width/2);
}

-(int)calcFontWidth:(int)font_height
{
    if (font_height< 20)
    {
        return 16;
    }
    else if (font_height< 28)
    {
        return 24;
    }
    else if (font_height< 40)
    {
        return 32;
    }
    else if (font_height< 56)
    {
        return 48;
    }
    else
    {
        return 64;
    }
}
-(int)calcTextStartPosition:(ALIGN)align startx:(int)startx endx:(int)endx font_height:(int)font_height enlargeX:(int)enlargeX text:(NSString*)text
{
    if(endx < startx)
    {
        int t = endx;
        endx = startx;
        startx = t;
    }
    if (align == LEFT)
    return startx;
    
    int width = endx - startx;
    
    
    int x = 0;
    int font_width = [self calcFontWidth:font_height];
    enlargeX++;
    int font_total_width = [self calcTextWidth:font_width text:text]*enlargeX;
    if(font_total_width > width)
        return startx;
    switch(align)
    {
        case CENTER:
        x = (self.printInfo.escPageWidth - font_total_width)/2;
        break;
        case RIGHT:
        x = self.printInfo.escPageWidth - font_total_width;
        break;
        default:
        x = startx;
        break;
    }
    return x;
}

-(BOOL)drawOut:(ALIGN)align startx:(int)startx endx:(int)endx y:(int)y text:(NSString*)text fontHeight:(int)fontHeight bold:(Boolean)bold reverse:(Boolean)reverse underLine:(Boolean)underLine deletLine:(Boolean)deleteLine enlargeX:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY rotateAngle:(ROTATE)rotateAngle
{
    int x = [self calcTextStartPosition:align startx:startx endx:endx font_height:fontHeight enlargeX:enlargeX text:text];
    return [self drawOut:x y:y text:text fontHeight:fontHeight bold:bold reverse:reverse underLine:underLine deletLine:deleteLine enlargeX:enlargeX enlargeY:enlargeY rotateAngle:rotateAngle];
}
@end
