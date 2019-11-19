//
//  WrapDatas.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/1.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAX_DATA_SIZE (1024*20)

@interface WrapDatas : NSObject{
    Byte _buffer[MAX_DATA_SIZE];
    int _offset;
    int _sendedDataLength;
    int leftDataLength;

}
@property (getter=getDataLength,readonly)int dataLength;
-(BOOL) addData:(Byte *)data length:(int)length;
-(BOOL) addByte:(Byte)byte;
-(BOOL) addShort:(ushort)data;
-(BOOL) add:(NSString *)text;
-(NSData*) getData:(int)sendLength;
-(void) reset;


@end
