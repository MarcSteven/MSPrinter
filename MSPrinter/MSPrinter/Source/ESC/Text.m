//
//  Text.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//
#import "Text.h"
#import "ESC.h"
//#import "Printer.h"

@implementation Text

//设置字体放大效果
-(BOOL)setFontEnlarge:(TEXT_ENLARGE)enlarge
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x21];
    return [self.printInfo.wrap addByte:(Byte)enlarge];
}

//设置字体ID
-(BOOL)setFontID:(FONT_ID)id
{
    switch(id)
    {
        case ASCII_16x32:
        case ASCII_24x48:
        case ASCII_32x64:
        case GBK_32x32:
        case GB2312_48x48:
            if(self.printInfo.model == VMP02 ||self.printInfo.model == ULT113x)
            {
              
                return true;
            }
            break;
        default:
            break;
    }
    
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x4D];
    return [self.printInfo.wrap addByte:(Byte)id];
}

//设置字体高度
-(BOOL)setFontHeight:(FONT_HEIGHT)height
{
    switch(height)
    {
        case x24:
            [self setFontID:ASCII_12x24];
            [self setFontID:GBK_24x24];
           
            break;
        case x16:
            
            [self setFontID:ASCII_8x16];
            [self setFontID:GBK_16x16];
            break;
        case x32:
            [self setFontID:ASCII_16x32];
            [self setFontID:GBK_32x32];
            break;
        case x48:
            [self setFontID:ASCII_24x48];
            [self setFontID:GB2312_48x48];
            break;
        case x64:
            [self setFontID:ASCII_32x64];

            break;
        default:
            return false;
    }	
    return true;
}

//设置字体加粗效果
-(BOOL)setBold:(BOOL)bold
{
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x45];
    return [self.printInfo.wrap addByte:(Byte)bold];
}

//绘制文本
-(BOOL)drawOut:(NSString*)text{
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text{
   
    if (![self setXY:x y:y]) {
        return false;
    }
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(int)x y:(int)y enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text{
   if (![self setXY:x y:y])
        return false;
    if (![self setFontEnlarge:enlarge])
        return false;
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(FONT_HEIGHT)height text:(NSString*)text{
    if (![self setFontHeight:height]) {
        return false;
    }
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text {
    if (![self setXY:x y:y])
        return false;
    if (![self setFontHeight:height])
        return false;
    if (![self setFontEnlarge:enlarge])
        return false;
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text{
    if (![self setXY:x y:y])
        return false;
    if (![self setFontHeight:height])
        return false;
    if (![self setFontEnlarge:enlarge])
        return false;
   if (![self setBold:bold])
        return false;
   return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold text:(NSString*)text{
    if (![self setXY:x y:y])
        return false;
    if (![self setFontHeight:height])
        return false;
    if (![self setBold:bold])
        return false;
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(ALIGN)align height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text{
    if(![self setAlign:align])
        return false;
    if(![self setFontHeight:height])
        return false;
    if(![self setBold:bold])
        return false;
    if (![self setFontEnlarge:enlarge])
        return false;
    return [self.printInfo.wrap add:text];
}

-(BOOL)drawOut:(ALIGN)align bold:(BOOL)bold text:(NSString*)text{
    if(![self setAlign:align])
        return false;
    if(![self setBold:bold])
        return false;
    return [self.printInfo.wrap add:text];
}

-(BOOL)printOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text
{
    if (![self setXY:x y:y]) return FALSE;
    if (bold)  if(![self setBold:true]) return FALSE;
    if(![self setFontHeight:height])  return FALSE;
    if (![self setFontEnlarge:enlarge]) return FALSE;
    if (![self.printInfo.wrap add:text]) return FALSE;
    [self feedEnter];
  
    if (bold) if(![self setBold:false]) return FALSE;
    if(![self setFontHeight:x24])  return FALSE;
    return [self setFontEnlarge:TEXT_ENLARGE_NORMAL];
}

-(BOOL)printOut:(ALIGN)align height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text
{
    if(![self setAlign:align])   return FALSE;
    if(![self setFontHeight:height]) return FALSE;
    if (bold) if(![self setBold:true]) return FALSE;
    if (![self setFontEnlarge:enlarge])  return FALSE;
    if (![self.printInfo.wrap add:text])  return FALSE;
    [self feedEnter];

    if(![self setAlign:LEFT])   return FALSE;
    if(![self setFontHeight:x24]) return FALSE;
    if(![self setBold:false]) return FALSE;
    return [self setFontEnlarge:TEXT_ENLARGE_NORMAL];
}

-(BOOL)printOut:(NSString*)text
{
    if (![self.printInfo.wrap add:text])
        return false;
    return [self feedEnter];
}

@end
