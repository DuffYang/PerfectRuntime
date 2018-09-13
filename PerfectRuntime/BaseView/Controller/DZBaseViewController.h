//
//  DZBaseViewController.h
//  DZStudy
//
//  Created by 杨东正 on 2017/3/21.
//  Copyright © 2017年 Dong Zheng Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBaseViewModel.h"

@interface DZBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@end
