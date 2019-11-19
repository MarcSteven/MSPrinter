//
//  Image.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/3/30.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "Image.h"

@implementation Image{
    
}

@synthesize m_width;
@synthesize m_height;
@synthesize m_datasize;

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

-(Byte)isBlackDots:(Byte*)data height:(int)height x:(int)x y:(int)y{
    int bw =(height-1)/8 + 1;
    return data[y*bw + x];
}

-(Boolean) PixelIsBlack:(int)color type:(int)gray_threshold{
    int red = ((color & 0x00FF0000) >> 16);
    int green = ((color & 0x0000FF00) >> 8);
    int blue = color & 0x000000FF;
    int grey = (int) ((float) red * 0.299 + (float) green * 0.587 + (float) blue * 0.114);
    return (grey < gray_threshold);
}

- (UIColor*) getRGB:(int)x type:(int)y
{
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * self.m_width;
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    CGFloat red   = (m_rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (m_rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (m_rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (m_rawData[byteIndex + 3] * 1.0) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    
}



-(Byte*)PicToByte:(UIImage*)image
{
    // 1.
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width =                 CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    // 2.
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width,     sizeof(UInt32));
    
    // 3.
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context =     CGBitmapContextCreate(pixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    
    // 4.
    CGContextDrawImage(context, CGRectMake(0,     0, width, height), inputCGImage);
    
    // 5. Cleanup
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    // 2.
    UInt32 * currentPixel = pixels;
    
    //    NSMutableArray* my_array=[[NSMutableArray alloc]init];
    Byte* my_array=(Byte*) calloc(width*height,sizeof(Byte));;
    
    
    int index=0;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            // 3.
            UInt32 color = *currentPixel;
            
            //            int red = ((color & 0x00FF0000) >> 16);
            //            int green = ((color & 0x0000FF00) >> 8);
            //            int blue = color & 0x000000FF;
            //            int mycolor = (int) ((float) red * 0.299 + (float) green * 0.587 + (float) blue * 0.114);
            
            
            //            int color2=(int)color;
            //            printf("%d,",color2);
            //            printf("%3.0f ",     (R(color)+G(color)+B(color))/3.0);
            //            printf("%3.0f ",     (R(color)+G(color)+B(color))/3.0);
            NSInteger mycolor=(int)((R(color)+G(color)+B(color))/3.0);
            //            NSString *str=;
            //            if (mycolor>128) {
            //                str = [ [NSString alloc] initWithFormat:@"1"];
            //            }else
            //            {
            //                str = [ [NSString alloc] initWithFormat:@"0"];
            //            }
            my_array[index]=mycolor;
            //            [my_array addObject:mycolor];
            // 4.
            index++;
            currentPixel++;
        }
        printf("\n");
    }
    
    int count = (int)((height - 1) / 8+ 1);
    
    Byte* my_array2=(Byte*) calloc(width*count,sizeof(Byte));
    int index2=0;
    for (int k=0; k<count; k++) {
        for (int i=0; i<width; i++) {
            my_array2[index2]=my_array[i+k*width*count];
            index2++;
        }
    }
    //    NSLog(@"%@",my_array);
    //    m_rawData=(Byte*)pixels;
    return (Byte*)my_array2;
}




//把一幅图像分割成高度为8个点的小图片来打印
-(BOOL) printOut:(int)x width:(int)width height:(int)height mode:(IMAGE_MODE)mode data:(Byte*)data dataLength:(int)dataLength sleepTime:(int)sleepTime{
    if (width >  self.printInfo.escPageWidth) {
        return FALSE;
    }

    if (mode == SINGLE_WIDTH_8_HEIGHT || mode == DOUBLE_WIDTH_8_HEIGHT)
    {
    }
    else
    {
        return FALSE;
    }

    int count;
    count = (height - 1) / 8 + 1;
    if (dataLength != width * count) {
        return false;
    }
    [self setLineSpace:0];
    for (int i = 0; i < count; i++)
    {
        [self setXY:x y:0];
       
        [self.printInfo.wrap addByte:0x1B];
        [self.printInfo.wrap addByte:0x2A];
        [self.printInfo.wrap addByte:(Byte)mode];
        [self.printInfo.wrap addShort:(ushort)width];
        [self.printInfo.wrap addData:(data + i * width) length:width];
        [self feedEnter];
        
    }
    return [self setLineSpace:8];
}

//打印一行
-(BOOL) printOutOneLine:(Byte*)data dataLength:(int)dataLenght{
    [self.printInfo.wrap addByte:0x1F];
    [self.printInfo.wrap addByte:0x10];
    [self.printInfo.wrap addShort:dataLenght];
    return [self.printInfo.wrap addData:data length:dataLenght];
}

-(BOOL) drawOut:(int)x y:(int)y imageWidthDots:(int)imageWidthDots imageHeightDots:(int)imageHeightDots mode:(IMAGE_ENLARGE)mode imageData:(Byte*)imageData {
    if (![self setXY:x y:y])
        return FALSE;
    return [self _drawOut:imageWidthDots imageHeightDots:imageHeightDots mode:mode imageData:imageData];
}

-(BOOL)_drawOut:(int)imageWidthDots imageHeightDots:(int)imageHeightDots mode:(IMAGE_ENLARGE)mode imageData:(Byte*)imageData
{
    int Y_Byte = (imageHeightDots - 1) / 8 + 1; // 位图Y轴方向象素点的字节数；
    int X_Byte = (imageWidthDots - 1) / 8 + 1; // 位图X轴方向象素点的字节输，表示需要X_Byte幅8
    int size= Y_Byte * 8;
    // x BmpHeight的位图拼成目标位图；
    Byte* DotsBuf = (Byte*)calloc(size, sizeof(Byte));// 存放8 x BmpHeight位图的点阵数据；
    memset(DotsBuf, 0, size);
    
    int DotsBufIndex = 0; // 8xBmpHeight数据索引
    int DotsByteIndex = 0; // 原始位图数据索引
    for (int i = 0; i < X_Byte; i++) {
        for (int j = 0; j < 8; j++) {
            for (int k = 0; k < Y_Byte; k++) {
                DotsByteIndex = k * imageWidthDots + i * 8 + j;
                if ((i << 3) + j < imageWidthDots) // 当宽度大于位图实际宽度是，点阵数据为0，因为定义位图宽度为8的整数倍，而实际宽度可能不是整数倍
                    DotsBuf[DotsBufIndex++] = (Byte) imageData[DotsByteIndex];
                else
                    DotsBuf[DotsBufIndex++] = 0x00;
            }
        }
        DotsBufIndex = 0;
        [self userImageDownloadIntoRAM:1 yBytes:Y_Byte data:DotsBuf length:size];// 定义位图
        [self userImageDrawout:mode];// 打印定义位图
    }
    free(DotsBuf);
    return TRUE;
}

-(BOOL)_drawOutChar:(int)imageWidthDots imageHeightDots:(int)imageHeightDots
               mode:(IMAGE_ENLARGE)mode imageData:(char*)imageData
{
    int Y_Byte = (imageHeightDots - 1) / 8 + 1; // 位图Y轴方向象素点的字节素；
    int X_Byte = (imageWidthDots - 1) / 8 + 1; // 位图X轴方向象素点的字节素，表示需要X_Byte幅8
    // x BmpHeight的位图拼成目标位图；
    
    Byte* DotsBuf = (Byte*)calloc(Y_Byte * 8, sizeof(Byte));// 存放8 x BmpHeight位图的点阵数据；
    for (int i = 0; i < Y_Byte * 8; i++)
    DotsBuf[i] = 0;
    int DotsBufIndex = 0; // 8xBmpHeight数据索引
    int DotsByteIndex = 0; // 原始位图数据索引
    for (int i = 0; i < X_Byte; i++) {
        for (int j = 0; j < 8; j++) {
            for (int k = 0; k < Y_Byte; k++) {
                DotsByteIndex = k * imageWidthDots + i * 8 + j;
                if ((i << 3) + j < imageWidthDots) // 当宽度大于位图实际宽度是，点阵数据为0，因为定义位图宽度为8的整数倍，而实际宽度可能不是整数倍
                DotsBuf[DotsBufIndex++] = (Byte) imageData[DotsByteIndex];
                else
                DotsBuf[DotsBufIndex++] = 0x00;
            }
        }
        DotsBufIndex = 0;
        
        [self userImageDownloadIntoRAM:i yBytes:Y_Byte data:DotsBuf length:Y_Byte * 8];// 定义位图
        [self userImageDrawout:mode];// 打印定义位图
    }
    free(DotsBuf);
    return true;
}


-(BOOL)userImageDrawout:(IMAGE_ENLARGE)mode{
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x2F];
    return [self.printInfo.wrap addByte:(Byte)mode];
}

// / <summary>
// / 图像数据下载到打印机内存
// / 1)图像数据扫描方式是从左到右，从上到下
// / 2)数据总大小:X_BYTES * Y_BYTES *8
// / 3)X方向点数 X_BYTES * 8
// / 4)Y方向点数 Y_BYTES * 8
// / </SUMMARY>
-(BOOL)userImageDownloadIntoRAM:(int)xBytes yBytes:(int)yBytes data:(Byte*)data length:(int)length{
    if (xBytes <= 0)   return FALSE;
    if (yBytes <= 0 || yBytes > 127)   return FALSE;
    int all_data_size = xBytes * yBytes * 8;
    
    if (all_data_size > 1024)   return FALSE;
    if (all_data_size != length)  return FALSE;
    
    [self.printInfo.wrap addByte:0x1D];
    [self.printInfo.wrap addByte:0x2A];
    [self.printInfo.wrap addByte:(Byte) xBytes];
    [self.printInfo.wrap addByte:(Byte) yBytes];
  
    return [self.printInfo.wrap addData:data length:length];
}

// / <summary>
// / 根据数组绘制图像到打印机画板
// / 1)图像高度不能大于对打印机画板高度
// / 2)由于图像并没有立即输出，还可以继续在相应的x,y坐标绘制打印对象
// / </summary>
-(BOOL)drawOut:(int)x y:(int)y imageWidthDots:(int)ImageWidthDots
imageHeightDots:(int)imageHeightDots moda:(IMAGE_ENLARGE)mode imageData:(Byte*)imageData
{
  if(![self setXY:x y:y])
    return false;
    return [self _drawOut:ImageWidthDots imageHeightDots:imageHeightDots mode:mode imageData:imageData];
}

// / <summary>
// / 根据数组绘制图像到打印机画板
// / 1)图像高度不能大于对打印机画板高度
// / 2)由于图像并没有立即输出，还可以继续在相应的x,y坐标绘制打印对象
// / </summary>
-(BOOL)drawOutChar:(int)x y:(int)y imageWidthDots:(int)imageWidthDots
imageHeightDot:(int)imageHeightDots mode:(IMAGE_ENLARGE)mode imageData:(char*)imageData{
    if(![self setXY:x y:y])
    return false;
    return [self _drawOutChar:imageWidthDots imageHeightDots:imageHeightDots mode:mode imageData:imageData];
}

// / <summary>
// / 根据bitmap对象，使用自定义位图方式绘制图像到打印画板
// / 1)图像高度不能大于对打印机画板高度
// / 2)由于图像并没有立即输出，还可以继续在相应的x,y坐标绘制打印对象
// / </summary>
-(BOOL)drawOut:(int)x y:(int)y bitmap:(UIImage*)bitmap
{
    int width = bitmap.size.width;
    int height = bitmap.size.height;
    int canvasMaxHeight=0;
    if (width > self.printInfo.escPageWidth)// || height > this.canvasMaxHeight)
    {
        return false;
    }
    if (height > canvasMaxHeight)
    {
        return false;
    }
    
    ImageConvert *conver;
    conver=[[ImageConvert alloc]init];
    Byte*data=[conver CovertImageVertical:bitmap type:128 type:8];
    
    if (data == NULL)
    {
        free((__bridge void *)(conver));
        free(data);
        return false;
    }
    
    
    if(![self setXY:x y:y])
    {
        free((__bridge void *)(conver));
        free(data);
        return false;
    }
    
    return [self _drawOut:width imageHeightDots:height mode:IMAGE_ENLARGE_NORMAL imageData:data];

}

// / <summary>
// / 根据bitmap对象打印图片
// / 1)适用于所有厂家及所有型号的POS打印机
// / 2)图像立即输出,不能在图像上绘制文字
// / </summary>
-(Boolean)printOut:(int)x bitmap:(UIImage*)bitmap sleep_time:(int)sleep_time{
    int width = bitmap.size.width;
    int height = bitmap.size.height;
    if (width > self.printInfo.escPageWidth)
    return false;
    
    ImageConvert *conver;
    conver=[[ImageConvert alloc]init];
    Byte*data=[conver CovertImageVertical:bitmap type:128 type:8];
    if (data == NULL)
    free((__bridge void *)(conver));
    free(data);
    return false;
    return [self _printOut:x width:width height:height mode:SINGLE_WIDTH_8_HEIGHT data:data sleep_time:sleep_time];
}

// / <summary>
// / 从上到下把一副大图片分割成n=((height-1)/8+1)个小图片,每个小图像宽width，高8个点。
// / 1)适用于所有厂家及型号的POS打印机
// / </summary>
-(Boolean)_printOut:(int)x width:(int)width height:(int)height
               mode:(IMAGE_MODE)mode data:(Byte[])data sleep_time:(int)sleep_time {
    if (width > self.printInfo.escPageWidth) {
        return false;
    }
    
    if (mode == SINGLE_WIDTH_8_HEIGHT
        || mode == DOUBLE_WIDTH_8_HEIGHT)
    {
    }
    else
    {
        
        return false;
    }
    int count; // 分割成多少副图片
    count = (height - 1) / 8 + 1;
    if (sizeof(data) != width * count) {
        return false;
    }
    [self setLineSpace:0];  // 设置行间距为0
    
    for (int i = 0; i < count; i++)
    {
        [self setXY:x y:0];

 
        [self.printInfo.wrap addByte:0x1B];
        [self.printInfo.wrap addByte:0x2A];
        [self.printInfo.wrap addByte:mode];
        [self.printInfo.wrap addShort:width];
        [self.printInfo.wrap addByte:*data];
        [self.printInfo.wrap add:@"\r\n"];
        [NSThread sleepForTimeInterval:sleep_time];
        
    }
    [self setLineSpace:8];// 恢复原始值 行间距为8
    
  [self.printInfo.wrap add:@"\r\n"];
    return true;
}

// / <summary>
// / 根据图片路径，使用自定义位图方式绘制图像到打印画板
// / 1)图像高度不能大于对打印机画板高度
// / 2)由于图像并没有立即输出，还可以继续在相应的x,y坐标绘制打印对象
// / </summary>
//-(Boolean)drawOut:(int)x y:(int)y image_path:(NSString)image_path{
//    if (new File(image_path).exists()) {
//        Bitmap bitmap = BitmapFactory.decodeFile(image_path);
//        return drawOut(x, y, bitmap);
//    } else {
//        return false;
//    }
//}


// / <summary>
// / 根据文件路径打印快速打印图片
// / 1)此为济强电子独有指令，不兼容别的品牌的打印机
// / 2)此方法是把一副大图片，分割成n多副小图片(高度为base_image_height)来打印。
// / 3)根据上位机的数据传输速度，可以调整base_image_height的大小来获得不同的图像打印速度。
// / 4)使用此方法，不可以在其余区域绘制别的东西。如果需要在图片上绘制别的打印对象请使用drawOut相关函数
// / 5)需要配合最新的打印机固件使用
// / </summary>

//-(Boolean)printOutFast:(int)x image_path:(NSString)image_path sleep_time:(int)sleep_time
//     base_image_height:(int)base_image_height
//{
//    if (new File(image_path).exists())
//    {
//        Bitmap bitmap = BitmapFactory.decodeFile(image_path);
//        return printOutFast(x, bitmap, sleep_time, base_image_height);
//    } else
//    {
//
//        return false;
//    }
//}






@end
