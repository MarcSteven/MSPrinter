//
//  JPLTextArea.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/8/20.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "MyPeripheral.h"
#import "PrinterInfo.h"
#import "JPLBase.h"
#import "JPLText.h"
#import "Text.h"

@interface JPLTextArea : JPLBase




-(BOOL) setArea:(int)x y:(int)y width:(int)width height:(int)height;
-(BOOL)drawOut:(int)x y:(int)y text:(NSString*)text;
-(BOOL)drawOut:(NSString*)text;
-(BOOL)setFontBold:(BOOL) bold;
-(BOOL)setFontEnlarge:(JPL_TEXT_ENLARGE)enlargeX enlargeY:(JPL_TEXT_ENLARGE)enlargeY;
-(BOOL)setFont:(FONT_ID)ascID hzID:(FONT_ID)hzID;
@end
