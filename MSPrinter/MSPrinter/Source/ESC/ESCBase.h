//
//  ESCBase.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#include "PrinterType.h"
//#import "MyPeripheral.h"
#import "PrinterInfo.h"

@interface ESCBase : NSObject{

}
//@property (retain) MyPeripheral* port;
@property (nonatomic, strong) CBPeripheral *port;


@property (retain) PrinterInfo* printInfo;
@property (assign) Byte *buffer;

//设置行间距
-(BOOL) setLineSpace:(int) dots;
//设置打印对象对齐方式
-(BOOL) setAlign:(ALIGN) align;
//换行回车
-(BOOL) feedEnter;
- (BOOL) setXY:(int)x y:(int)y;
//打印机恢复开机初始状态
-(BOOL)restorePrinter;

@end
