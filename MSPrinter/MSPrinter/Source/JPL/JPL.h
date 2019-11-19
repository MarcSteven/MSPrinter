//
//  JPL.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLBase.h"
#import "PrinterInfo.h"
#import "JPLText.h"
#import "Page.h"
#import "JPLImage.h"
#import "JPLBarcode.h"
#import "JPLGraphic.h"
#import "JPLTextArea.h"

@interface JPL : JPLBase
@property (retain) JPLText* text;
@property (retain) Page* page;
@property (retain) JPLImage* image;
@property (retain) JPLBarcode* barcode;
@property (retain) JPLGraphic* grahic;
@property (retain) JPLTextArea* textarea;





typedef NS_ENUM(Byte, FEED_TYPE)
{
    MARK_OR_GAP,
    LABEL_END,
    MARK_BEGIN,
    MARK_END,
    BACK, //后退
};



-(BOOL)feedMarkOrGap:(int)dots;
-(BOOL)feedNextLabelBegin;
-(BOOL)gotoGPL;

@end
