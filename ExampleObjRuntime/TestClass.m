//
//  TestClass.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>

@implementation TestClass

- (instancetype)init
{
    self = [super init];
    if (self) {
        kkk = 10;
    }
    return self;
}



@end
