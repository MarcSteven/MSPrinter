//
//  Barcode.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/3.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCBase.h"
#import "PrinterInfo.h"
#import "Code128.h"

@interface Barcode : ESCBase
typedef NS_ENUM(Byte, BAR_UNIT)
{
    BARx1=(1),
    BARx2=(2),
    BARx3=(3),
    BARx4=(4),
    
};


typedef NS_ENUM(Byte, BAR_TEXT_POS)
{
    NONE,
    TOP,
    BOTTOM,
};


typedef NS_ENUM(Byte, BAR_TEXT_SIZE)
{
    BAR_ASCII_12x24,
    BAR_ASCII_8x16,
};

typedef NS_ENUM(Byte, ESC_BAR_2D)
{
    PDF417=0,
    DATAMATIX=1,
    QRCODE=2,
    GRIDMATIX=10,
};



-(BOOL)code128_auto_printOut:(ALIGN)align unit:(BAR_UNIT)unit height:(int)height pos:(BAR_TEXT_POS)pos size:(BAR_TEXT_SIZE)size str:(NSString*)str;
-(BOOL) CODE128_base:(Byte*)data length:(int)length;
-(BOOL)code128_auto_drawOut:(ALIGN)align unit:(BAR_UNIT)unit height:(int)height pos:(BAR_TEXT_POS)pos size:(BAR_TEXT_SIZE)size str:(NSString*)str;
-(BOOL) EAN8_auto:(NSString*)str;
-(BOOL)barcode2D_QRCode:(Byte)version ecc:(Byte)ecc text:(NSString*)text length:(int)length;
-(BOOL)barcode2D_QRCode:(int)x y:(int)y unit:(BAR_UNIT)unit version:(int)version ecc:(int)ecc text:(NSString*)text length:(int)length;


@end
