//
//  JPLText.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MyPeripheral.h"
#import "PrinterInfo.h"
#import "JPLBase.h"

@interface JPLText : JPLBase

typedef NS_ENUM(Byte, JPL_TEXT_ENLARGE)
{
    x1,
    x2,
    x3,
    x4,
};

typedef NS_ENUM(Byte, ROTATE)
{
    ROTATE_0=(0x00),
    ROTATE_90=(0x01),
    ROTATE_180=(0x10),
    ROTATE_270=(0x11),
};

-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text;

-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text fontHeight:(int)fontHeight bold:(Boolean)bold reverse:(Boolean)reverse underLine:(Boolean)underLine deletLine:(Boolean)deleteLine enlargeX:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY rotateAngle:(ROTATE)rotateAngle;



-(BOOL)drawOut:(ALIGN)align startx:(int)startx endx:(int)endx y:(int)y text:(NSString*)text fontHeight:(int)fontHeight bold:(Boolean)bold reverse:(Boolean)reverse underLine:(Boolean)underLine deletLine:(Boolean)deleteLine enlargeX:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY rotateAngle:(ROTATE)rotateAngle;
@end
