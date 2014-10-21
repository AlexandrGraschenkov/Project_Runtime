//
//  NSString_AgeExt.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "NSString_AgeExt.h"
#import <objc/runtime.h>

@implementation NSString (AgeExt)
static char defaultHashKey;

- (NSNumber *)agesCount
{
    return objc_getAssociatedObject(self, &defaultHashKey);
}

- (void)setAgesCount:(NSNumber *)agesCount
{
    objc_setAssociatedObject(self, &defaultHashKey, agesCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
