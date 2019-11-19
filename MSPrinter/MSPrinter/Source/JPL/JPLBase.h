//
//  JPLBase.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#include "PrinterType.h"
#import "PrinterInfo.h"

@interface JPLBase : NSObject

//@property (retain) MyPeripheral* port;
@property (nonatomic, strong) CBPeripheral *port;
@property (retain) PrinterInfo* printInfo;
@property (assign) Byte *buffer;



@end
