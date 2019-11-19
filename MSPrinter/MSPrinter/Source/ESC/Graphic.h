//
//  Graphic.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/31.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCBase.h"


@interface Graphic : ESCBase
{
    Byte* cmd;
}
-(BOOL)linedrawOut:(int)startPoint endPoint:(int)endPoint;




@end
