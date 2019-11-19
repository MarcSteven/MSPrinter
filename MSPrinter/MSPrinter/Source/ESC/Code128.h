//
//  Code128.h
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/3.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//


#import <Foundation/Foundation.h>

#define CODE128_FORMAT_A  1
#define CODE128_FORMAT_B  2
#define CODE128_FORMAT_C  3

#define V_CODE_A  101
#define V_CODE_B  100
#define V_CODE_C  99
#define V_START_A  103
#define V_START_B  104
#define V_START_C  105

@interface Code128 : NSObject
{
    NSString* decode_string ;//用来放解码后的字符串
    NSArray *Code128Rule;
}
@property Byte* encode_data;//用来放编码后的字符数组
@property int encode_data_size;

-(Byte*)encode:(NSString*)src;
-(BOOL)decode:(Byte*)str length:(int)length;

@end
