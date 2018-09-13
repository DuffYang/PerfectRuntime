//
//  PerfectObject.h
//  PerfectRuntime
//
//  Created by Yang,Dongzheng on 2018/9/13.
//  Copyright © 2018年 Yang,Dongzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PerfectObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;

/// 动态替换方法
+ (void)replaceMethod;

/// 动态增加属性
+ (void)addObject;

/// 自动归档与解档
+ (void)coding;

/// 动态添加方法
+ (void)doSing;

/// 字典转模型
+ (void)dictionaryToModel;

/// 动态变量控制
+ (void)changeName;

@end
