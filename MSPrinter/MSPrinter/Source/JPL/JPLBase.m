//
//  JPLBase.m
//  MSPrinter
//
//  Created by Marc Zhao on 15/4/15.
//  Copyright (c) 2015年 Marc Zhao. All rights reserved.
//


#import "JPLBase.h"

@implementation JPLBase
@synthesize port;
@synthesize printInfo;
@synthesize buffer;

-(id) init{
    self = [super init];
    port = nil;
    printInfo = nil;
    return self;
}


@end
