//
//  ViewController.h
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
@private
    int k;
}
@property (nonatomic, strong) NSArray *someArr;
@property (nonatomic, strong) NSDictionary *vaka;
@property (nonatomic, assign) int count;

@end

