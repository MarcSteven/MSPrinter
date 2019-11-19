//
//  Printer.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ESC.h"
#import "JPL.h"
#import "PrinterInfo.h"

@interface JQPrinter : NSObject //<MyPeripheralDelegate>
{
    WrapDatas *wrap;
}
@property(retain)ESC * esc;
@property(retain)JPL * jpl;
@property(nonatomic,copy)CBPeripheral * port;
@property(nonatomic,copy)PrinterInfo* printerInfo;
@property(assign) BOOL sendFlag;
@property(assign) BOOL sendFinish;





@end
