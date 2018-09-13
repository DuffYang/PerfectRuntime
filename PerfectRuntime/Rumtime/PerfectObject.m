//
//  PerfectObject.m
//  PerfectRuntime
//
//  Created by Yang,Dongzheng on 2018/9/13.
//  Copyright © 2018年 Yang,Dongzheng. All rights reserved.
//

#import "PerfectObject.h"
#include <objc/runtime.h>
#import "NSObject+DictionaryToModel.h"

@implementation PerfectObject

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(perfect);
        SEL swizzledSelector = @selector(newPerfect);
        
        Method originalMethod = class_getInstanceMethod(class,originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class,swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)newPerfect {
    NSLog(@"成功替换方法");
}

/// 动态替换方法
+ (void)replaceMethod {
    PerfectObject *obj = [PerfectObject new];
    [obj perfect];
}

/// 方法替换
- (void)perfect {
    NSLog(@"原来的方法");
}

/// 动态增加属性
static const char associatedKey;
+ (void)addObject {
    PerfectObject *obj = [PerfectObject new];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"我是PerfectObject动态添加的" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    objc_setAssociatedObject(obj, &associatedKey, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self getAssociatedObject:obj];
}
+ (void)getAssociatedObject:(PerfectObject *)obj {
    UIAlertView *alert = objc_getAssociatedObject(obj, &associatedKey);
    [alert show];
}

/// 自动归档与解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

+ (void)coding {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
    NSString *file = [path stringByAppendingPathComponent:@"perfectObject.archiver"];
    PerfectObject *object = [[PerfectObject alloc] init];
    object.name = @"yangdongzheng";
    object.age = @"18";
    object.sex = @"男";
    BOOL result = [NSKeyedArchiver archiveRootObject:object toFile:file];
    if (result) {
        NSLog(@"good");
    }
    PerfectObject *perfect = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"%@ %@ %@ %@", perfect, perfect.name, perfect.age, perfect.sex);
}

/// 动态添加方法
+ (void)doSing {
    PerfectObject *p = [[PerfectObject alloc] init];
    [p performSelector:@selector(sing)];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(sing)) {
        Class class = [self class];
        SEL singSelector = @selector(sing);
        Method singMethod = class_getInstanceMethod(class,singSelector);
        class_addMethod(class, singSelector, method_getImplementation(singMethod), method_getTypeEncoding(singMethod));
        // 处理完返回YES
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (void)sing {
    NSLog(@"新添加了唱歌的方法");
}

/// 字典转模型
+ (void)dictionaryToModel {
    NSDictionary *studentInfo = @{@"name" : @"Kobe Bryant",
                                  @"age" : @"18",
                                  @"sex" : @"男"};
    PerfectObject *student = [[PerfectObject alloc] init];
    [student setValuesForKeysWithDictionary:studentInfo];
    
    PerfectObject *student1 = [PerfectObject modelWithDict:studentInfo];
    NSLog(@"student = %@,%@,%@,%@",student1, student1.name, student1.age, student1.sex);
}

/// 动态变量控制
+ (void)changeName {
    PerfectObject *student = [[PerfectObject alloc] init];
    student.name = @"zhangsan";
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([student class], &count);//count获取Person的属性个数，为2；
    for (int i = 0; i<count; i++){
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);//获取属性名称
        NSString *proname = [NSString stringWithUTF8String:varName];//C字符串转换
        if ([proname isEqualToString:@"_name"]) {  //这里别忘了给属性加下划线，通过属性名称
            object_setIvar(student, var, @"yangdongzheng");//object_setIvar(类名, 属性名称, 变更后的名称)
            break;
        }
    }
    NSLog(@"zhangsan change name  is %@",student.name);//已成功通过runtime更改属性的值
}

@end
