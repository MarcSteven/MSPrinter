//
//  Barcode.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/3.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "Barcode.h"

@implementation Barcode

/*
 * 设置1维条码高度
 */
-(BOOL)set1DHeight:(int)height
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x68];
    return [self.printInfo.wrap addByte:(Byte)height];
}

/*
 * 设置1维，2维条码基本单元大小
 */
-(BOOL)setUnit:(BAR_UNIT)unit
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x77];
    return [self.printInfo.wrap addByte:(Byte)unit];
}

/*
 * 设置条码文字位置
 */
-(BOOL)setTextPosition:(BAR_TEXT_POS)pos
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x48];
    return [self.printInfo.wrap addByte:(Byte)pos];
}

/*
 * 设置条码文字大小
 */
-(BOOL)setTextSize:(BAR_TEXT_SIZE)size
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x66];
    return [self.printInfo.wrap addByte:(Byte)size];
}

/*
 * EAN校验和
 */
-(Byte)EAN_checksum:(Byte*)str Len:(int)str_len
{
    int i;
    int check_sum = 0;
    
    if ( str_len%2 == 1) //奇数个
    {
        for( i = 0; i < str_len; i++)
        {
            if(i%2==0)
            check_sum += (str[i]-'0')*3;
            else
            check_sum += (str[i]-'0');
        }
    }
    else //偶数个
    {
        for( i = 0; i < str_len; i++)
        {
            if(i%2==0)
            check_sum += (str[i]-'0');
            else
            check_sum += (str[i]-'0')*3;
        }
    }
    check_sum = check_sum%10;
    if(check_sum != 0)
    check_sum = 10 - check_sum;
    check_sum = '0'+check_sum;
    return (Byte)check_sum;
}

/*
 * 获取UPCE的校验和
 */
-(Byte)UPCE_getChecksum:(Byte*)src length:(int)length
{
    Byte* buf =(Byte*)calloc(12, sizeof(Byte));
    int i;
    int j=0;
    if (src[6] == '0' || src[6] == '1' || src[6] == '2')
    {
        buf[j++] = src[0];
        buf[j++] = src[1];
        buf[j++] = src[2];
        buf[j++] = src[6];
        for (i = 0; i < 4; i++)
        buf[j++] = '0';
        buf[j++] = src[3];
        buf[j++] = src[4];
        buf[j++] = src[5];
    }
    else if (src[6] == '3')
    {
        buf[j++] = src[0];
        buf[j++] = src[1];
        buf[j++] = src[2];
        buf[j++] = src[3];
        for (i = 0; i < 5; i++)
        buf[j++] = '0';
        buf[j++] = src[4];
        buf[j++] = src[5];
    }
    else if (src[6] == '4')
    {
        buf[j++] = src[0];
        buf[j++] = src[1];
        buf[j++] = src[2];
        buf[j++] = src[3];
        buf[j++] = src[4];
        for (i = 0; i < 5; i++)
        buf[j++] = '0';
        buf[j++] = src[5];
    }
    else
    {
        buf[j++] = src[0];
        buf[j++] = src[1];
        buf[j++] = src[2];
        buf[j++] = src[3];
        buf[j++] = src[4];
        buf[j++] = src[5];
        for (i = 0; i < 4; i++)
        buf[j++] = '0';
        buf[j++] = src[6];
    }
    return [self EAN_checksum:buf Len:11];
}

/*
 * UPCE基本方式，此函数不会计算校验和。需要你自己在data中算好校验和
 */
-(BOOL)UPCE_base:(Byte*)data length:(int)length
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x01];
    return [self.printInfo.wrap addData:data length:length];
}

/*
 * UPCE自动计算校验和
 * --String str：必须7个字符
 */
-(BOOL)UPCE_auto:(NSString*)text
{
    Byte* buf =(Byte*)calloc(9, sizeof(Byte));
    if(text.length!= 7) //检查长度
    return false;
    for(int i = 0; i < text.length; i++) //检查是否为数字
    {
        
        if( [text characterAtIndex:i] < '0'|| [text characterAtIndex:i] >'9')
        return false;
    }
    if( [text characterAtIndex:0]!='0' &&  [text characterAtIndex:1]!='1')
    return false;
    for(int i = 0;i < 7;i++)
    {
        buf[i] = (Byte)[text characterAtIndex:i];
    }

    buf[7] = [self UPCE_getChecksum:buf length:7];
    buf[8] = 0;
    BOOL r = [self UPCE_base:buf length:9];
    free(buf);
    return r;
    
}

/*
 * UPCA基本方式，此函数不会计算校验和。需要你自己在data中算好校验和
 */
-(BOOL)UPCA_base:(Byte*)data length:(int)length
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x00];
    return [self.printInfo.wrap addData:data length:length];
}
/*
 * UPCA自动计算校验和
 * --String str：必须11个字符
 */
-(BOOL)UPCA_auto:(NSString*)str
{
    Byte* buf = (Byte*)calloc(13, sizeof(Byte));
    if(str.length != 11)
    return false;
    for(int i = 0; i < str.length; i++) //检查是否为数字
    {
        if([str characterAtIndex:i] <'0'||[str characterAtIndex:i]  >'9')
        return false;
    }
    for(int i = 0; i < str.length; i++)
    {
        buf[i] = (Byte)[str characterAtIndex:i] ;
    }

    buf[11] = [self EAN_checksum:buf Len:11];
    buf[12] = 0;
    return [self UPCE_base:buf length:13];
}
///*
// * EAN13基本方式，此函数不会计算校验和。需要你自己在data中算好校验和
// */
-(BOOL) EAN13_base:(Byte*)data length:(int)length
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x03];
    return [self.printInfo.wrap addData:data length:length];
}
///*
// * EAN13自动计算校验和
// * 输入参数：
// * --String str：必须12个字符
// */
-(BOOL)EAN13_auto:(NSString*)str
{
    Byte*buf=(Byte*)calloc(14, sizeof(Byte));
    if(str.length!= 12)
    return false;
    for(int i = 0; i < str.length; i++) //检查是否为数字
    {
        if([str characterAtIndex:i] <'0'||[str characterAtIndex:i] >'9')
        return false;
    }
    for(int i = 0; i < str.length; i++)
    {
        buf[i] = (Byte)[str characterAtIndex:i];
    }
   
    buf[12]=[self EAN_checksum:buf Len:12];
    buf[13] = 0;
    BOOL r = [self EAN13_base:buf length:14];
    free(buf);
    return	r;
}
///*
// * EAN8基本方式，此函数不会计算校验和。需要你自己在data中算好校验和
// */
-(BOOL) EAN8_base:(Byte*)data length:(int)length
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x02];
    return [self.printInfo.wrap addData:data length:length];
}
///*
// * EAN8自动计算校验和
// * 输入参数：
// * --String str：必须7个字符
// */
-(BOOL) EAN8_auto:(NSString*)str
{
    if(str.length != 7)
    return false;
    for(int i = 0; i < str.length; i++) //检查是否为数字
    {
        if([str characterAtIndex:i] <'0'||[str characterAtIndex:i] >'9')
        return false;
    }
    Byte* buf = (Byte*)calloc(9, sizeof(Byte));
    for(int i = 0; i < str.length; i++)
    {
        buf[i] = (Byte)[str characterAtIndex:i];
    }
    buf[7] = [self EAN_checksum:buf Len:7];
    buf[8] = 0;
    BOOL r = [self EAN8_base:buf length:9];
    free(buf);
    return r;
}
/*
 * CODE128基本方式，此函数不会计算校验和。需要你自己在data中算好校验和
 */
-(BOOL) CODE128_base:(Byte*)data length:(int)length
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x08];
    [self.printInfo.wrap addData:data length:length];
    return [self.printInfo.wrap addByte:0x00];
}

/*
 * Code128自动计算校验和
 * 输入参数：
 * --String str：
 */
-(BOOL) CODE128_auto:(NSString*)str
{
    Code128 *code128 = [[Code128 alloc]init];
    Byte* buf =[code128 encode:str];
    if (buf == nil)
    return false;
    return [self CODE128_base:buf length:code128.encode_data_size];
}
/*
 * Code128自动计算校验和
 */
-(BOOL)code128_auto_drawOut:(ALIGN)align unit:(BAR_UNIT)unit height:(int)height pos:(BAR_TEXT_POS)pos size:(BAR_TEXT_SIZE)size str:(NSString*)str
{
    if(![self setAlign:align])   return FALSE;
    [self setUnit:unit];
    if(![self set1DHeight:height])   return FALSE;
    [self setTextPosition:pos];
    [self setTextSize:size];
    
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x6B];
    [self.printInfo.wrap addByte:0x18];
    return [self.printInfo.wrap add:str];
    
}

-(BOOL)code128_auto_printOut:(ALIGN)align unit:(BAR_UNIT)unit height:(int)height pos:(BAR_TEXT_POS)pos size:(BAR_TEXT_SIZE)size str:(NSString*)str
{
    if(![self code128_auto_drawOut:align unit:unit height:height pos:pos size:size str:str])
    
    return false;
    [self feedEnter];
    if(![self setAlign:LEFT])
    return false;
    return true;
}


/// <summary>
/// 选择2D条码类型
/// </summary>
/// <param name="type"></param>
/// <returns></returns>
-(BOOL)barcode2D_SetType:(ESC_BAR_2D)type
{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x5A];
    return [self.printInfo.wrap addByte:(Byte)type];

}
/// <summary>
/// 绘制2D条码
/// </summary>
/// <param name="m"></param>
/// <param name="n"></param>
/// <param name="k"></param>
/// <param name="text"></param>
/// <returns></returns>
-(BOOL)barcode2D_DrawOut:(Byte)m n:(Byte)n k:(Byte)k text:(NSString*)text length:(int)length
{
//    Byte*data = nil;
//    data = text.getBytes("GBK");
//    if (data == 0)
//    {
//        return FALSE;//data is empty
//    }
    
    [self.printInfo.wrap addByte:0x1B];
    [self.printInfo.wrap addByte:0x5A];
    [self.printInfo.wrap addByte:m];
    [self.printInfo.wrap addByte:n];
    [self.printInfo.wrap addByte:(Byte)k];
//    [self.printInfo.wrap addByte:(Byte)data.length];
//    [self.printInfo.wrap addByte:(Byte)(data.length >> 8];
        [self.printInfo.wrap addByte:(Byte)length];
        [self.printInfo.wrap addByte:(Byte)length >> 8];
    return [self.printInfo.wrap add:text];
}


/// <summary>
/// 绘制QRCode
/// </summary>
/// <param name="version">版本号,当version = 0，自动计算版本号，通过版本号可以可以QRCode尺寸大小</param>
/// <param name="ecc">纠错级别，0~3,纠错级别越高越容易识别，但是可容纳内容减小</param>
/// <param name="text">条码内容</param>
/// <returns></returns>
-(BOOL)barcode2D_QRCode:(Byte)version ecc:(Byte)ecc text:(NSString*)text length:(int)length
{
    [self barcode2D_SetType:QRCODE];
    return [self barcode2D_DrawOut:version n:ecc k:(Byte)0 text:text length:length];
    
}
/// <summary>
///  绘制QRCode,根据参数
/// </summary>
/// <param name="x">x</param>
/// <param name="y">y</param>
/// <param name="unit">条码基本单元宽度</param>
/// <param name="version">版本号,当version = 0，自动计算版本号，通过版本号可以可以QRCode尺寸大小</param>
/// <param name="ecc">纠错级别，0~3,纠错级别越高越容易识别，但是可容纳内容减小</param>
/// <param name="text">条码内容</param>
/// <returns></returns>
-(BOOL)barcode2D_QRCode:(int)x y:(int)y unit:(BAR_UNIT)unit version:(int)version ecc:(int)ecc text:(NSString*)text length:(int)length
{
    [self setXY:x y:y];
    [self setUnit:unit];
    [self barcode2D_SetType:QRCODE];
    return [self barcode2D_DrawOut:version n:ecc k:(Byte)0 text:text length:length];

}
/// <summary>
/// 绘制PDF417
/// </summary>
/// <param name="columnNumber">每列容纳字符数目</param>
/// <param name="ecc">纠错能力,0~8,级别越高，纠正码字数越多，纠正能力越强，条码也越大</param>
/// <param name="hwratio">长宽比列</param>
/// <param name="text">条码内容</param>
/// <returns></returns>
-(BOOL)barcode2D_PDF417:(Byte)columnNumber ecc:(Byte)ecc hwratio:(Byte)hwratio text:(NSString*)text length:(int)lenght
{
    [self barcode2D_SetType:PDF417];
    return [self barcode2D_DrawOut:columnNumber n:ecc k:hwratio text:text length:lenght];

}
/// <summary>
/// 绘制DATAMatrix
/// </summary>
/// <param name="text">条码内容</param>
/// <returns></returns>
-(BOOL)barcode2D_DATAMatrix:(NSString*)text length:(int)length
{
    [self barcode2D_SetType:DATAMATIX];
    return [self barcode2D_DrawOut:(Byte)0  n:(Byte)0 k:(Byte)0 text:text length:length];
}
/// <summary>
/// 绘制GRIDMatrix
/// </summary>
/// <param name="ecc">纠错级别</param>
/// <param name="text">条码内容</param>
/// <returns></returns>
-(BOOL)barcode2D_GRIDMatrix:(Byte)ecc text:(NSString*)text length:(int)length
{
    [self barcode2D_SetType:GRIDMATIX];
    return [self barcode2D_DrawOut:ecc n:(Byte)0 k:(Byte)0 text:text length:length];
}



@end
