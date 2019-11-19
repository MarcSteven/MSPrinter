//
//  JPLBarcode.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/16.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLBase.h"
#import "PrinterInfo.h"
#import "Code128.h"

@interface JPLBarcode : JPLBase

typedef NS_ENUM(Byte, BAR_1D_TYPE)
{
    UPCA_AUTO=(0x41),
    UPCE_AUTO=(0x42),
    EAN8_AUTO=(0x43),
    EAN13_AUTO=(0x44),
    CODE39_AUTO=(0x45),
    ITF25_AUTO=(0x46),
    CODABAR_AUTO=(0x47),
    CODE93_AUTO=(0x48),
    CODE128_AUTO=(0x49),
};

typedef NS_ENUM(Byte, JPL_BAR_UNIT)
{
    JPL_x1=(1),
    JPL_x2=(2),
    JPL_x3=(3),
    JPL_x4=(4),
    JPL_x5=(5),
    JPL_x6=(6),
    JPL_x7=(7),
};

typedef NS_ENUM(Byte, BAR_ROTATE)
{
    ANGLE_0,
    ANGLE_90,
    ANGLE_180,
    ANGLE_270
};

typedef NS_ENUM(Byte, QRCODE_ECC)
{
    LEVEL_L,//可纠错7%
    LEVEL_M,//可纠错15%
    LEVEL_Q,//可纠错25%
    LEVEL_H,//可纠错30%
};

typedef NS_ENUM(Byte, JPL_ROTATE)
{
    JPL_ROTATE_0=(0x00),
    JPL_ROTATE_90=(0x01),
    JPL_ROTATE_180=(0x10),
    JPL_ROTATE_270=(0x11),
};

-(BOOL)code128:(int)x y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width rotate:(BAR_ROTATE)rotate text:(NSString*)text;
-(BOOL) QRCode:(int)x y:(int)y version:(int)version ecc:(QRCODE_ECC)ecc unit_width:(JPL_BAR_UNIT)unit_width rotate:(BAR_ROTATE)rotate text:(NSString*)text;

//-(BOOL)code128:(ALIGN)align startx:(int)x endx:(int)endx y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width roate:(BAR_ROTATE)rotate text:(NSString*)text;
-(BOOL)code128:(ALIGN)align startx:(int)startx endx:(int)endx y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width roate:(BAR_ROTATE)rotate text:(NSString*)text;
-(BOOL)code128:(ALIGN)align y:(int)y bar_height:(int)bar_height unit_width:(JPL_BAR_UNIT)unit_width roate:(BAR_ROTATE)rotate text:(NSString*)text;


@end
