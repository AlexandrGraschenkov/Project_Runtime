//
//  UIViewController+EmptyNavBack.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "UIViewController+EmptyNavBack.h"
#import <objc/runtime.h>


@implementation UIViewController (EmptyNavBack)

+ (void)load
{
    [self swizzleSelector:@selector(viewDidLoad) withSelector:@selector(my_viewDidLoad)];
}

+ (void)swizzleSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, sel1);
    Method swizzledMethod = class_getInstanceMethod(class, sel2);
    
    BOOL didAddMethod = class_addMethod(class,
                                        sel1,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            sel2,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)my_viewDidLoad
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:barItem];
    [self my_viewDidLoad];
}

@end
