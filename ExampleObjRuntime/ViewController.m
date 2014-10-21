//
//  ViewController.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+PropertyDescription.h"
#import "UIAlertView+Blocks.h"
#import "TestClass.h"
#import "NSString_AgeExt.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *str = @"123123";
//    str.agesCount = @10;
//    
//    TestClass *obj = [TestClass new];
//    NSLog(@"%@", [obj valueForKey:@"kkk"]);
    
    _count = 123;
    _vaka = @{@"Key" : @"Value"};
    
    UIViewController *contr = [UIViewController new];
    
    NSLog(@"%@", [super my_description]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hi" message:@"123" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [[[alert actions] addAction:alert.cancelButtonIndex handler:^{
        NSLog(@"%@", @"Cancel pressed");
    }] addAction:1 handler:^{
        NSLog(@"%@", @"Ok pressed");
    }];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ %ld", @"Clicked", (long)buttonIndex);
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%@", @"will present");
}

@end
