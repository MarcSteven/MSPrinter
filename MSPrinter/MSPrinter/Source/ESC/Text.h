//
//  Text.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MyPeripheral.h"
#import "PrinterInfo.h"
#import "ESCBase.h"

typedef NS_ENUM(Byte, TEXT_ENLARGE) {
    TEXT_ENLARGE_NORMAL = (0x00),
    TEXT_ENLARGE_HEIGHT_DOUBLE = (0x01),
    TEXT_ENLARGE_WIDTH_DOUBLE = (0x10),
    TEXT_ENLARGE_HEIGHT_WIDTH_DOUBLE = (0x11),
};

typedef NS_ENUM(Byte, FONT_ID)
{
    ASCII_12x24=(0x00),
    ASCII_8x16=(0x01),
    ASCII_16x32=(0x03),
    ASCII_24x48=(0x04),
    ASCII_32x64=(0x05),
    GBK_24x24=(0x10),
    GBK_16x16=(0x11),
    GBK_32x32=(0x13),
    GB2312_48x48=(0x14),
};

typedef NS_ENUM(Byte, FONT_HEIGHT)
{
    x24,
    x16,
    x32,
    x48,
    x64,
};

@interface Text : ESCBase{
}

-(BOOL)drawOut:(NSString*)text;
-(BOOL)setFontID:(FONT_ID)id;
-(BOOL)setFontHeight:(FONT_HEIGHT)height;
-(BOOL)setBold:(BOOL)bold;
-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text;
-(BOOL)drawOut:(int)x y:(int)y enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text;
-(BOOL)drawOut:(FONT_HEIGHT)height text:(NSString*)text;
-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text ;
-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text;
-(BOOL)drawOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold text:(NSString*)text;
-(BOOL)drawOut:(ALIGN)align height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text;
-(BOOL)drawOut:(ALIGN)align bold:(BOOL)bold text:(NSString*)text;
-(BOOL)printOut:(int)x y:(int)y height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text;
-(BOOL)printOut:(ALIGN)align height:(FONT_HEIGHT)height bold:(BOOL)bold enlarge:(TEXT_ENLARGE)enlarge text:(NSString*)text;
-(BOOL)printOut:(NSString*)text;


@end
