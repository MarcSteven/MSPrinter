//
//  MSCImageConverter.h
//  MSPrinter
//
//  Created by Marc Zhao on 2015/3/25.
//  Copyright © 2015-2019 Marc Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageConvert : NSObject {
    
      Byte* m_rawData;
        Byte* m_data;
    }
@property(nonatomic,readwrite)int m_width;
@property(assign)int m_height;
@property(assign)int m_datasize;

-(Byte*)CovertImageVertical:(UIImage*)bitmap type:(int)gray_threshold type:(int)column_dots;
-(Byte)CovertImageHorizontal:(UIImage*)bitmap gray_threshold:(int)gray_threshold;
-(Boolean) PixelIsBlack:(int)color type:(int)gray_threshold;
- (UIColor*) getRGB:(int)x type:(int)y;


@end

NS_ASSUME_NONNULL_END
