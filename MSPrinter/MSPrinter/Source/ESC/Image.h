//
//  Image.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "MyPeripheral.h"
#import "PrinterInfo.h"
#import "ESCBase.h"
#import "Image.h"
#import "MSCImageConverter.h"


typedef NS_ENUM(Byte, IMAGE_MODE)
{
    SINGLE_WIDTH_8_HEIGHT=(0x01),
    DOUBLE_WIDTH_8_HEIGHT=(0x00),
    SINGLE_WIDTH_24_HEIGHT=(0x21),
    DOUBLE_WIDTH_24_HEIGHT=(0x20),
};


typedef NS_ENUM(Byte, IMAGE_ENLARGE)
{
    IMAGE_ENLARGE_NORMAL,
    IMAGE_ENLARGE_HEIGHT_DOUBLE,
    IMAGE_ENLARGE_WIDTH_DOUBLE,
    IMAGE_ENLARGE_HEIGHT_WIDTH_DOUBLE
};

@interface Image : ESCBase{
    Byte*cmd;
    Byte* m_rawData;
    Byte* m_data;
    
}

@property(nonatomic,readwrite)int m_width;
@property(assign)int m_height;
@property(assign)int m_datasize;

-(BOOL) printOut:(int)x width:(int)width height:(int)height mode:(IMAGE_MODE)mode data:(Byte*)data dataLength:(int)dataLength sleepTime:(int)sleepTime;

-(BOOL) printOutOneLine:(Byte*)data dataLength:(int)dataLenght;
-(BOOL) drawOut:(int)x y:(int)y imageWidthDots:(int)imageWidthDots imageHeightDots:(int)imageHeightDots mode:(IMAGE_ENLARGE)mode imageData:(Byte*)imageData;
-(Byte*)PicToByte:(UIImage*)image;
-(Byte*)CovertImageVertical:(UIImage*)bitmap type:(int)gray_threshold type:(int)column_dots;
-(Boolean)printOut:(int)x bitmap:(UIImage*)bitmap sleep_time:(int)sleep_time;

@end
