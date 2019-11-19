//
//  Code128.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/3.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//


#import "Code128.h"

@implementation Code128
@synthesize encode_data;
@synthesize encode_data_size;
-(id)init{
    self=[super init];
    if(self){
         encode_data = NULL; //用来放编码后的字符数组
         decode_string = @"";//用来放解码后的字符串
        Code128Rule = [NSArray arrayWithObjects:
                       @"11011001100",
                       @"11001101100",
                       @"11001100110",
                       @"10010011000",
                       @"10010001100",
                       @"10001001100",
                       @"10011001000",
                       @"10011000100",
                       @"10001100100",
                       @"11001001000",
                       @"11001000100",
                       @"11000100100",
                       @"10110011100",
                       @"10011011100",
                       @"10011001110",
                       @"10111001100",
                       @"10011101100",
                       @"10011100110",
                       @"11001110010",
                       @"11001011100",
                       @"11001001110",
                       @"11011100100",
                       @"11001110100",
                       @"11101101110",
                       @"11101001100",
                       @"11100101100",
                       @"11100100110",
                       @"11101100100",
                       @"11100110100",
                       @"11100110010",
                       @"11011011000",
                       @"11011000110",
                       @"11000110110",
                       @"10100011000",
                       @"10001011000",
                       @"10001000110",
                       @"10110001000",
                       @"10001101000",
                       @"10001100010",
                       @"11010001000",
                       @"11000101000",
                       @"11000100010",
                       @"10110111000",
                       @"10110001110",
                       @"10001101110",
                       @"10111011000",
                       @"10111000110",
                       @"10001110110",
                       @"11101110110",
                       @"11010001110",
                       @"11000101110",
                       @"11011101000",
                       @"11011100010",
                       @"11011101110",
                       @"11101011000",
                       @"11101000110",
                       @"11100010110",
                       @"11101101000",
                       @"11101100010",
                       @"11100011010",
                       @"11101111010",
                       @"11001000010",
                       @"11110001010",
                       @"10100110000",
                       @"10100001100",
                       @"10010110000",
                       @"10010000110",
                       @"10000101100",
                       @"10000100110",
                       @"10110010000",
                       @"10110000100",
                       @"10011010000",
                       @"10011000010",
                       @"10000110100",
                       @"10000110010",
                       @"11000010010",
                       @"11001010000",
                       @"11110111010",
                       @"11000010100",
                       @"10001111010",
                       @"10100111100",
                       @"10010111100",
                       @"10010011110",
                       @"10111100100",
                       @"10011110100",
                       @"10011110010",
                       @"11110100100",
                       @"11110010100",
                       @"11110010010",
                       @"11011011110",
                       @"11011110110",
                       @"11110110110",
                       @"10101111000",
                       @"10100011110",
                       @"10001011110",
                       @"10111101000",
                       @"10111100010",
                       @"11110101000",
                       @"11110100010",
                       @"10111011110",
                       @"10111101110",
                       @"11101011110",
                       @"11110101110",
                       @"11010000100",//START A
                       @"11010010000", //START B
                       @"11010011100" //START C
                       ,nil ];
        
    }
    return self;
}

-(BOOL)charIsNumber:(char)data
{
    if(data <'0' || data>'9')
    return false;
    return true;
}

-(BOOL)charIsCodeB:(char)ch
{
    return (ch >= 32 && ch <= 127);
}

-(BOOL)charIsNotCodeB:(char)ch
{
    return (ch <= 31);
}

-(BOOL)charIsCodeA:(char)ch
{
    return (ch <= 95);
}

-(BOOL)charIsNotCodeA:(char)ch
{
    return (ch >= 96 && ch <= 127);
}

-(BOOL)isContinueNum:(NSString*)str index:(int)index max:(int)max
{
    if (index + 4 > max)
    return false; //防止数据访问越界
    [str characterAtIndex:index+0];
    return ([self charIsNumber:[str characterAtIndex:(index+0)]]
            && [self charIsNumber:[str characterAtIndex:(index+1)]]
            &&[self charIsNumber:[str characterAtIndex:(index+2)]]
            &&[self charIsNumber:[str characterAtIndex:(index+3)]]
            );
   
}

/*
 * 把原始字符串编码为带校验和方式的code128字符数组
 */
-(Byte*)encode:(NSString*)src
{
    Byte* dstc = (Byte*)calloc(80*4, sizeof(Byte));
    int src_len = src.length;
    int last_code_type = 0;
    int len = 0;
    int checkcodeID = 0;
    int ch;
    
    int CodeType = 0;// CODE128_FORMAT_A
    
    if (src_len > 80) // 最多80个字符。
        goto err;

    if ([self isContinueNum:src index:0 max:src_len]){
        CodeType = CODE128_FORMAT_C;
        dstc[len++] = '{';
        dstc[len++] = 'C';
        checkcodeID = V_START_C;
    } else if ([self charIsCodeB:[src characterAtIndex:0]]){
        CodeType = CODE128_FORMAT_B;
        dstc[len++] = '{';
        dstc[len++] = 'B';
        checkcodeID = V_START_B;
    } else if ([self charIsCodeA:[src characterAtIndex:0]]){
        CodeType = CODE128_FORMAT_A;
        dstc[len++] = '{';
        dstc[len++] = 'A';
        checkcodeID = V_START_A;
    } else
    return nil;
    
    for (int i = 0; i < src_len; i++) {
        if ([src characterAtIndex:i] > 127)
        goto err ;// CODE128 范围0~127
    }
    for (int i = 0, k = 1; i < src_len;) {
        switch (CodeType) {
            case CODE128_FORMAT_C:// CODE128_FORMAT_C:
            last_code_type = CODE128_FORMAT_C;
            for (; i < src_len; i += 2) {
                if ((i + 1) < src_len) {
                    if([self charIsNumber:[src characterAtIndex:i ]]
                    && [self charIsNumber:[src characterAtIndex:(i+1)]]){
                                dstc[len++] = (Byte) [src characterAtIndex:i];
                                dstc[len++] = (Byte) [src characterAtIndex:(i+1)];
                        checkcodeID += (( [src characterAtIndex:i] - 0x30) * 10 + ([src characterAtIndex:(i+1)] - 0x30)) * (k++);
                    } else {
                        if( ([self charIsNumber:[src characterAtIndex:i]] && [self charIsNotCodeB:[src characterAtIndex:(i+1)]])
                           || [self charIsNotCodeB:[src characterAtIndex:i]])
                        {
                            CodeType = CODE128_FORMAT_B;
                            dstc[len++] = '{';
                            dstc[len++] = 'B';
                            checkcodeID += V_CODE_B * (k++);
                            break;
                        } else if(([self charIsNumber:[src characterAtIndex:i]]&&[self charIsNotCodeA:[src characterAtIndex:(i+1)]])
                                   ||[self charIsNotCodeA:[src characterAtIndex:i]])
                        {
                            CodeType = CODE128_FORMAT_A;
                            dstc[len++] = '{';
                            dstc[len++] = 'A';
                            checkcodeID += V_CODE_A * (k++);
                            break;
                        }
                    }
                } else {
                        if ([self charIsCodeB:[src characterAtIndex:i]]){
                        CodeType = CODE128_FORMAT_B;
                        dstc[len++] = '{';
                        dstc[len++] = 'B';
                        checkcodeID += V_CODE_B * (k++);
                        break;
        
                    }else if ([self charIsCodeA:[src characterAtIndex:i ]]){
                        CodeType = CODE128_FORMAT_A;
                        dstc[len++] = '{';
                        dstc[len++] = 'A';
                        checkcodeID += V_CODE_A * (k++);
                        break;
                    }
                }
            }
            break;
            case CODE128_FORMAT_B:// CODE128_FORMAT_B
            last_code_type = CODE128_FORMAT_B;
            for (; i < src_len; i++) {
                    if([self isContinueNum:src index:i max:src_len]){
                    CodeType = CODE128_FORMAT_C;
                    dstc[len++] = '{';
                    dstc[len++] = 'C';
                    checkcodeID += V_CODE_C * (k++);
                    break;
                }else if ( [self charIsNotCodeB:[src characterAtIndex:i]]){
                    CodeType = CODE128_FORMAT_A;
                    dstc[len++] = '{';
                    dstc[len++] = 'A';
                    checkcodeID += V_CODE_A * (k++);
                    break;
                } else {
                    if ([src characterAtIndex:i] == '{') {
                        dstc[len++] = '{';
                        dstc[len++] = '{';
                    } else {
                        dstc[len++] = (Byte) [src characterAtIndex:i];
                    }
                    checkcodeID += (k++) * ([src characterAtIndex:i]- 32);
                }
            }
            break;
            case CODE128_FORMAT_A:// CODE128_FORMAT_A:
            last_code_type = CODE128_FORMAT_A;
            for (; i < src_len; i++) {
        
                    if([self isContinueNum:src index:i max:src_len]){
                    CodeType = CODE128_FORMAT_C;
                    dstc[len++] = '{';
                    dstc[len++] = 'C';
                    checkcodeID += V_CODE_C * (k++);
                    break;
              
                     }else if ( [self charIsNotCodeA:[src characterAtIndex:i]]){
                    CodeType = CODE128_FORMAT_B;
                    dstc[len++] = '{';
                    dstc[len++] = 'B';
                    checkcodeID += V_CODE_B * (k++);
                    break;
                } else {
                    dstc[len++] = (Byte) [src characterAtIndex:i];
                    ch = [src characterAtIndex:i];
                    if (ch >= 32 && ch <= 95)
                    checkcodeID += (k++) * (ch - 32);
                    else if (ch <= 31 && ch >= 0)
                    checkcodeID += (k++) * (ch + 64);
                }
            }
            break;
            default:
            return nil;
        }
    }
    checkcodeID = checkcodeID % 103;
    switch (last_code_type)// 处理校验和
    {
        case 1:// CODE128_FORMAT_A:
        if (checkcodeID >= 0 && checkcodeID <= 63) // 0~63
        dstc[len++] = (Byte) (checkcodeID + 32);
        else if (checkcodeID >= 64 && checkcodeID <= 95) // 64~95
        dstc[len++] = (Byte) (checkcodeID - 64);
        else if (checkcodeID == 96) {
            dstc[len++] = '{';
            dstc[len++] = '3';
        } else if (checkcodeID == 97) {
            dstc[len++] = '{';
            dstc[len++] = '2';
        } else if (checkcodeID == 98) {
            dstc[len++] = '{';
            dstc[len++] = 'S';
        } else if (checkcodeID == 99) {
            dstc[len++] = '{';
            dstc[len++] = 'C';
        } else if (checkcodeID == 100) {
            dstc[len++] = '{';
            dstc[len++] = 'B';
        } else if (checkcodeID == 101) {
            dstc[len++] = '{';
            dstc[len++] = '4';
        } else if (checkcodeID == 102) {
            dstc[len++] = '{';
            dstc[len++] = '1';
        }
        break;
        case 2:// CODE128_FORMAT_B:
        if (checkcodeID >= 0 && checkcodeID <= 95) {
            if (checkcodeID == 0x5B) // 转义'{'
            {
                dstc[len++] = '{';
                dstc[len++] = '{';
            } else
            dstc[len++] = (Byte) (checkcodeID + 32);
        } else if (checkcodeID == 96) {
            dstc[len++] = '{';
            dstc[len++] = '3';
        } else if (checkcodeID == 97) {
            dstc[len++] = '{';
            dstc[len++] = '2';
        } else if (checkcodeID == 98) {
            dstc[len++] = '{';
            dstc[len++] = 'S';
        } else if (checkcodeID == 99) {
            dstc[len++] = '{';
            dstc[len++] = 'C';
        } else if (checkcodeID == 100) {
            dstc[len++] = '{';
            dstc[len++] = '4';
        } else if (checkcodeID == 101) {
            dstc[len++] = '{';
            dstc[len++] = 'A';
        } else if (checkcodeID == 102) {
            dstc[len++] = '{';
            dstc[len++] = '1';
        }
        break;
        case 3:// CODE128_FORMAT_C:
        if (checkcodeID >= 0 && checkcodeID <= 99) {
            dstc[len++] = (Byte) (checkcodeID / 10 + 48);
            dstc[len++] = (Byte) (checkcodeID % 10 + 48);
        } else if (checkcodeID == 100) {
            dstc[len++] = '{';
            dstc[len++] = 'B';
        } else if (checkcodeID == 101) {
            dstc[len++] = '{';
            dstc[len++] = 'A';
        } else if (checkcodeID == 102) {
            dstc[len++] = '{';
            dstc[len++] = '1';
        }
        break;
        default:
        goto err ;
    }
  

    Byte*data =(Byte*)calloc(len+1, sizeof(Byte));
    memcpy(data, dstc, len);
    data[len] = 0;
    encode_data_size = len;
    return data;
err:
    free(dstc);
    return nil;
}



/*
 * 获取字符的索引号
 */
-(int)getCharIndex:(int)type c:(Byte)c
{
    if(type==0) //type A
    {
        if(c>=0x20&&c<=0x5f)
        return (int)c-0x20;
        else if(c<0x20) return (int)c+0x40;
        else if(c==0x80) return 103;
        else if(c==0x81) return  104;
        else if(c==0x82) return  105;
        else if(c==0x83) return  102;
        else if(c==0x84) return  97;
        else if(c==0x85) return  96;
        else if(c==0x86) return  101;
        else if(c==0x88) return  100;
        else if(c==0x89) return  99;
        else if(c==0x90) return  98;
        else return 255;
    }
    else if(type==1) //type B
    {
        if(c>=0x20&&c<=0x7f) return (int)c-0x20;
        else if(c==0x80) return 103;
        else if(c==0x81) return  104;
        else if(c==0x82) return  105;
        else if(c==0x83) return  102;
        else if(c==0x84) return  97;
        else if(c==0x85) return  96;
        else if(c==0x86) return  100;
        else if(c==0x87) return  101;
        else if(c==0x89) return  99;
        else if(c==0x90) return  98;
        else return 255;
    }
    else if(type==2) //type C
    {
        if(c<100) return c;
        else if(c==0x80) return 103;
        else if(c==0x81) return  104;
        else if(c==0x82) return  105;
        else if(c==0x83) return  102;
        else if(c==0x87) return  101;
        else if(c==0x88) return  100;
        else return 255;
    }
    else return 255;
}

/*
 * 追加条码的基本单元
 */
-(BOOL)addChar:(int)type ch:(Byte)ch
{

    int index = [self getCharIndex:type c:ch];
    if(index == 255) return FALSE;
    [decode_string stringByAppendingString:[Code128Rule objectAtIndex:index]];
    return true;
}

/*
 * 把带校验的code128文本解码为code128条码
 */
-(BOOL)decode:(Byte*)str length:(int)length
{
    int i;
    Byte c;
    int type=0;
    char Cc[3] = {0,0,0};
    int code_type=0;
    int str_len = length-1;
    for(i = 0; i < str_len;i++)
    {
        if(str[i]=='{')
        {
            if(str[i+1]=='C')
            {	
                code_type=1;
                if (str[i+2]=='{' && str[i+3]=='1')
                { 
                    i+=2;
                }
            }
            else if (str[i+1] == '{')
            {	
                code_type=0;
            }
            else 
            {	
                code_type=0;
            }			
            i++;
        }
        else
        {
            if(code_type==1)
            {	
                i++; 
            }
            else
            {	
            }
        }
    }				
    if(str[0]!='{') 
    return false;
    switch(str[1])
    {
        case 'A':
        type=0;
        c=0x80;
        break;
        case 'B':
        type=1;
        c=0x81;
        break;
        case 'C':
        type=2;
        c=0x82;
        break;
        default: 
        return false;
    }
    
    [self addChar:type ch:c];
    for(i=2;i<str_len;i++)
    {
        if(str[i]=='{')
        {
            switch(str[i+1])
            {
                case 'A':
                if(type!=0)
                {
                    c=0x87;
                    if(![self addChar:type ch:c])
                    return false;
                }
                type=0;
                i++;
                continue;
                case 'B':
                if(type!=1)
                {	
                    c=0x88;
                    if(![self addChar:type ch:c])
                    return false;
                }
                type=1;
                i++;
                continue;
                case 'C':
                if(type!=2)
                {	
                    c=0x89;	
                   if(![self addChar:type ch:c])
                    return false;
                }
                type=2;
                i++;
                continue;
                case '1':
                c=0x83;i++;
                break;
                case '2':
                c=0x84;i++;
                break;
                case '3':
                c=0x85;i++;break;
                case '4':
                c=0x86;i++;break;
                case 'S':
                c=0x90;i++;break;
                case '{':
                c='{';i++;break;
                default: 
                return false;
            }
           if(![self addChar:type ch:c])
            return false;
            continue;
        }
        else if(type==2)
        {
            Cc[0]=(char) str[i];
            Cc[1]=(char) str[i+1];
            Cc[2]=0;
            if(Cc[0]<'0'||Cc[0]>'9'||Cc[1]<'0'||Cc[1]>'9') 
            return false;
            c = (char) ((Cc[0]-'0')*10+(Cc[1]-'0'));
          if(![self addChar:type ch:c])
            return false;
            i++;
            continue;
        }
        else
        {
            c=(char) str[i];
           if(![self addChar:type ch:c]) 
            return false;
        }
    }
    [decode_string stringByAppendingString:@"1100011101011"];
    return true;
}



@end
