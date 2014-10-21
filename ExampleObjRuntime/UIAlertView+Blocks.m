//
//  UIAlertView+Blocks.m
//  ExampleObjRuntime
//
//  Created by Alexander on 20.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static char actionsKey;

@interface UIAlertViewActions () <UIAlertViewDelegate>
{
    NSMutableDictionary *handlers;
}
@property (nonatomic, weak) NSObject<UIAlertViewDelegate> *realDelegate;
@end

@implementation UIAlertViewActions

- (UIAlertViewActions *)addAction:(NSInteger)idx handler:(void (^)())handler
{
    if (!handlers) {
        handlers = [NSMutableDictionary new];
    }
    handlers[@(idx)] = [handler copy];
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^handler)() = handlers[@(buttonIndex)];
    if (handler) handler();
    if ([self.realDelegate respondsToSelector:_cmd]) { // _cmd -> название текущего метода, SEL
        [self.realDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:self.realDelegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.realDelegate methodSignatureForSelector:aSelector];
}

- (BOOL)isSelectorOfAlertViewProtocol:(SEL)selector
{
    struct objc_method_description hasMethod = protocol_getMethodDescription(@protocol(UIAlertViewDelegate), selector, NO, YES);
    return hasMethod.name != NULL;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self isSelectorOfAlertViewProtocol:aSelector]) {
        return [super respondsToSelector:aSelector] ?: [self.realDelegate respondsToSelector:aSelector];
    } else {
        return [super respondsToSelector:aSelector];
    }
}

@end


@implementation UIAlertView (Blocks)

+ (void)load
{
    [self swizzleSelector:@selector(my_setDelegate:) withSelector:@selector(setDelegate:)];
}

+ (void)swizzleSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, sel1);
    Method swizzledMethod = class_getInstanceMethod(class, sel2);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)my_setDelegate:(id)delegate
{
    UIAlertViewActions *actions = [self currentActionsHandler];
    if (actions) {
        actions.realDelegate = delegate;
        
        // в сеттере зачастую проверяют на какие методы отвечает делегат и сохраняют в BOOL значения
        // на всякий обновляем наш делегат
        [self my_setDelegate:nil];
        [self my_setDelegate:actions];
    } else {
        [self my_setDelegate:delegate];
    }
}

- (UIAlertViewActions *)currentActionsHandler
{
    return objc_getAssociatedObject(self, &actionsKey);
}

- (UIAlertViewActions *)actions
{
    UIAlertViewActions *actions = [self currentActionsHandler];
    if (!actions) {
        actions = [UIAlertViewActions new];
        actions.realDelegate = self.delegate;
        objc_setAssociatedObject(self, &actionsKey, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self my_setDelegate:actions];
    }
    return actions;
}

@end
