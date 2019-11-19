//
//  ESC.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "PrinterInfo.h"

#import "Barcode.h"
#import "Text.h"
#import "Image.h"
#import "Graphic.h"

@interface ESC : ESCBase{
}
@property (retain) Text* text;
@property (retain) Image* image;
@property (retain) Barcode* barcode;
@property (retain) Graphic* grahic;





-(BOOL)wakeUp;
-(BOOL)feedDots:(int)dots;
-(BOOL)feedLines:(int)lines;
-(BOOL)getPrinterStatue;

@end
