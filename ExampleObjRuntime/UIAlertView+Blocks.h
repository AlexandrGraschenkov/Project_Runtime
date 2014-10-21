//
//  UIAlertView+Blocks.h
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertViewActions : NSObject

- (UIAlertViewActions *)addAction:(NSInteger)idx handler:(void(^)())handler;

@end



@interface UIAlertView (Blocks)

- (UIAlertViewActions *)actions;

@end
