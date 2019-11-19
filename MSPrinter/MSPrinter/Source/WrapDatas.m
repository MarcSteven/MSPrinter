//
//  WrapDatas.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/1.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//


#import "WrapDatas.h"

@implementation WrapDatas
@synthesize dataLength;

-(id)init{
    self = [super init];
    _offset = 0;
    _sendedDataLength = 0;
    return self;
}

-(void)reset{
    _offset = 0;
    _sendedDataLength = 0;
}

-(int) getDataLength{
    return _offset;
}

-(BOOL) addData:(Byte *)data length:(int)length{
    if (_offset + length > MAX_DATA_SIZE)
        return FALSE;
    memcpy(_buffer + _offset, data, length);
    _offset += length;
    return TRUE;
}

-(BOOL) addByte:(Byte)byte{
    if (_offset + 1 > MAX_DATA_SIZE)
        return FALSE;
    _buffer[_offset++] = byte;
    return TRUE;
}

-(BOOL) addShort:(ushort)data{
    if (_offset + 2 > MAX_DATA_SIZE)
        return FALSE;
    _buffer[_offset++] = (Byte)data;
    _buffer[_offset++] = (Byte)(data>>8);
    return TRUE;
}

-(BOOL) add:(NSString *)text{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gbk = [text dataUsingEncoding:enc];
    Byte* gbkBytes = (Byte*)[gbk bytes]  ;
    if(![self addData:gbkBytes length:gbk.length])
       return FALSE;
    return [self addByte:0x00];
}

-(NSData*) getData:(int)sendLength{
    NSData *data;
    data = [[NSData alloc]initWithBytes:_buffer+_sendedDataLength length:sendLength];
    _offset -= sendLength;
    _sendedDataLength +=sendLength;
    return data;
}


@end
