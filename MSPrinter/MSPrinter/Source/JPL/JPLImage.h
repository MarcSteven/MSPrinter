//
//  JPLImage.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLBase.h"
//#import "MyPeripheral.h"
#import "PrinterInfo.h"

@interface JPLImage : JPLBase

typedef NS_ENUM(Byte, IMAGE_ROTATE)
{
    IMAGE_ANGLE_0,
    IMAGE_ANGLE_90,
    IMAGE_ANGLE_180,
    IMAGE_ANGLE_270
};

-(BOOL)drawOut:(int)x y:(int)y width:(int)width height:(int)height data:(Byte*)data Reverse:(Boolean)Reverse Rotate:(IMAGE_ROTATE)Rotate Enlarge:(int)EnlargeX EnlargeX:(int)EnlargeY;
-(BOOL)drawOut:(int)x y:(int)y width:(int)width height:(int)height data:(char*)data;



@end
