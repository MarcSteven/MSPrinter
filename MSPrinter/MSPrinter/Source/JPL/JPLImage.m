//
//  JPLImage.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//

#import "JPLImage.h"

@implementation JPLImage


-(BOOL)drawOut:(int)x y:(int)y width:(int)width height:(int)height data:(char*)data
{
    if(width < 0 || height < 0)
    return false;
    int HeightWriteUnit = 10;
    int WidthByte = ((width-1)/8+1);
    int HeightWrited = 0;
    int HeightLeft = height;
    while(true)
    {
        if(HeightLeft <= HeightWriteUnit)
        {
            [self.printInfo.wrap addByte:0x1A];
            [self.printInfo.wrap addByte:0x21];
            [self.printInfo.wrap addByte:0x00];
            [self.printInfo.wrap addShort:(short)x];
            [self.printInfo.wrap addShort:(short)y];
            [self.printInfo.wrap addShort:(short)width];
            [self.printInfo.wrap addShort:(short)HeightLeft];
            int index = HeightWrited*WidthByte;
            for(int i = 0; i < HeightLeft*WidthByte; i++)
            {
                [self.printInfo.wrap addByte:(Byte)data[index++]];
            }
            return true;
        }
        else
        {
            [self.printInfo.wrap addByte:0x1A];
            [self.printInfo.wrap addByte:0x21];
            [self.printInfo.wrap addByte:0x00];
            [self.printInfo.wrap addShort:(short)x];
            [self.printInfo.wrap addShort:(short)y];
            [self.printInfo.wrap addShort:(short)width];
            [self.printInfo.wrap addShort:(short)HeightWriteUnit];
            int index = HeightWrited*WidthByte;
            for(int i = 0; i < HeightWriteUnit*WidthByte; i++)
            {
               [self.printInfo.wrap addByte:(Byte)data[index++]];
            }
            y += HeightWriteUnit;
            HeightWrited += HeightWriteUnit;
            HeightLeft -= HeightWriteUnit;
        }
    }
}

-(BOOL)drawOut:(int)x y:(int)y width:(int)width height:(int)height data:(Byte*)data Reverse:(Boolean)Reverse Rotate:(IMAGE_ROTATE)Rotate Enlarge:(int)EnlargeX EnlargeX:(int)EnlargeY
{
    if(width < 0 || height < 0)
    return false;
    
    short ShowType = 0;
    if(Reverse) ShowType |= 0x0001;
    ShowType |= (Rotate << 1)&0x0006;
    ShowType |= (EnlargeX << 8)&0x0F00;
    ShowType |= (EnlargeY << 14)&0xF000;
    
    int HeightWriteUnit = 10;
    int WidthByte = ((width-1)/8+1);
    int HeightWrited = 0;
    int HeightLeft = height;
    while(true)
    {
        if(HeightLeft <= HeightWriteUnit)
        {
            [self.printInfo.wrap addByte:0x1A];
            [self.printInfo.wrap addByte:0x21];
            [self.printInfo.wrap addByte:0x01];
            [self.printInfo.wrap addShort:(short)x];
            [self.printInfo.wrap addShort:(short)y];
            [self.printInfo.wrap addShort:(short)width];
            [self.printInfo.wrap addShort:(short)HeightLeft];
            [self.printInfo.wrap addShort:(short)ShowType];
            int index = HeightWrited*WidthByte;
            for(int i = 0; i < HeightLeft*WidthByte; i++)
            {
                [self.printInfo.wrap addByte:(Byte)data[index++]];
            }
            return true;
        }
        else
        {
            [self.printInfo.wrap addByte:0x1A];
            [self.printInfo.wrap addByte:0x21];
            [self.printInfo.wrap addByte:0x00];
            [self.printInfo.wrap addShort:(short)x];
            [self.printInfo.wrap addShort:(short)y];
            [self.printInfo.wrap addShort:(short)width];
            [self.printInfo.wrap addShort:(short)HeightWriteUnit];
            [self.printInfo.wrap addShort:(short)ShowType];
            
            int index = HeightWrited*WidthByte;
            for(int i = 0; i < HeightWriteUnit*WidthByte; i++)
            {
                  [self.printInfo.wrap addByte:(Byte)data[index++]];
            }
            y += HeightWriteUnit;
            HeightWrited += HeightWriteUnit;
            HeightLeft -= HeightWriteUnit;
        }
    }
}




//-(BOOL)drawOut:(int)x y:(int)y res:(Resources)res id:(int)id rotate:(IMAGE_ROTATE)rotate
//{
////    UIImage  *bitmap = BitmapFactory.decodeResource(res, id);
//    UIImage  *bitmap = [[UIImage alloc]init];
//    int width =bitmap.size.width;
//    int height =bitmap.size.height;
//    if (width > param.pageWidth || height>param.pageHeight)
//    return false;
//    return drawOut(x,y,width,height,CovertImageHorizontal(bitmap,128),false,rotate,0,0);
//    [self drawOut:x y:y width:width height:height data:<#(Byte *)#> Reverse:FALSE Rotate:rotate Enlarge:0 EnlargeX:0];
//}


@end
