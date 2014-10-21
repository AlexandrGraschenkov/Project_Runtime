//
//  NSObject+PropertyDescription.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "NSObject+PropertyDescription.h"
#import <objc/runtime.h>
//#import <objc/message.h>

@implementation NSObject (PropertyDescription)

- (NSString *)my_description
{
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionary];
    unsigned int propertyCount;
    NSLog(@"%@", [self superclass]);
    objc_property_t *properties = class_copyPropertyList([self superclass], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        char const *propertyName = property_getName(properties[i]);
        const char *attr = property_getAttributes(properties[i]);
        if (attr[1] == '@' || attr[1] == 'i') {
            NSString *selector = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            SEL sel = sel_registerName([selector UTF8String]);
            if (attr[1] == '@') {
                if ([self respondsToSelector:sel]) {
                    NSObject * propertyValue = objc_msgSend(self, sel);
                    propertyValues[selector] = propertyValue.description ?: [NSNull null];
                }
            } else {
                int val = objc_msgSend(self, sel);
                propertyValues[selector] = @(val);
            }
        }
    }
    free(properties);
    return [NSString stringWithFormat:@"%@: %@", self.class, propertyValues];
}

@end
