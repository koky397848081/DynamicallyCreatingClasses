//
//  ViewController.m
//  动态创建类
//
//  Created by jingjing on 2017/6/12.
//  Copyright © 2017年 jingjing. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //创建一个UIview 的子类
    Class newClass = objc_allocateClassPair([UIView class], "xujingCustomView", 0);

    //为该类增加一个名为 report 的方法
    class_addMethod(newClass, @selector(report), (IMP)ReportFunction, "v@:");
    
    //注册类
    objc_registerClassPair(newClass);
    
    //创建类的实例
    id instanceOfNewClass = [[newClass alloc]init];
    [instanceOfNewClass performSelector: @selector(report)];
    
}

void ReportFunction(id self, SEL _cmd){
    NSLog(@"This object is %p",self);
    NSLog(@"@class is %@,and super is %@",[self class],[self superclass]);
    Class currentClass = [self class];
    for(int i=1;i<5;i++){
        NSLog(@"Following the isa pointer %d␣times␣gives␣%p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject's␣class␣is␣%p", [NSObject class]);
    NSLog(@"NSObject's␣meta␣class␣is␣%p", object_getClass([NSObject class]));
}

/*
 该代码的关键主要有以下几点:
 1. import rumtime 引关的头文件:objc/runtime.h。
 2. 使用objc_allocateClassPair方法创建新的类。
 3. 使用class_addMethod方法来给类增加新的方法。
 4. 使用objc_registerClassPair来注册新的类。
 5. 使用 object_getClass 方法来获得对象的 isa 指针所指向的对象。

 经过三次连续对象取 isa 指针，变成元类的地址，之后第四次取 isa 指针的地址，说明 NSObject 元类的 isa 指针确实是指向它自己的。
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
