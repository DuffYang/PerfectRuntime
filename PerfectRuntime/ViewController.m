//
//  ViewController.m
//  PerfectRuntime
//
//  Created by Yang,Dongzheng on 2018/9/13.
//  Copyright © 2018年 Yang,Dongzheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Runtime";
    
    NSArray *titles = @[@"系统方法替换",
                        @"动态增加属性",
                        @"自动归档与解档",
                        @"动态增加方法",
                        @"实现字典和模型的自动转换",
                        @"动态变量控制",
                        @"实现万能控制器跳转",
                        @"JSPatch热修复",
                        ];
    NSMutableArray *dataArray = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DZBaseViewModel *model = [DZBaseViewModel new];
        model.title = obj;
        [dataArray addObject:model];
    }];
    self.dataSource = dataArray;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [PerfectObject replaceMethod];
            break;
        case 1:
            [PerfectObject addObject];
            break;
        case 2:
            [PerfectObject coding];
            break;
        case 3:
            [PerfectObject doSing];
            break;
        case 4:
            [PerfectObject dictionaryToModel];
            break;
        case 5:
            [PerfectObject changeName];
            break;
        default:
            break;
    }
}

@end
