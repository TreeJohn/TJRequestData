//
//  ViewController.m
//  TJRequestDataDemo
//
//  Created by 平平 on 17/2/22.
//  Copyright © 2017年 TreeJohn. All rights reserved.
//

#import "ViewController.h"
#import "TJRequestData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)requestData {
    
    // 本demo适用于接口端以接口编号区分获取的项目
    // 如项目没用接口编号，可直接用defaultRequestData获取实例
    
    TJRequestData *req = [TJRequestData defaultRequestDataWithServiceId:@"S_07_10"];
    
    // 传入请求是需要的参数值
    req.param[@"equipmentType"] = @"2";
    req.param[@"channelNumber"] = @"10000";
    
    // 直接编写请求成功的代码即可，如果请求失败，服务器直接提示用户失败信息（toast）
    // 如有特殊失败处理，可传入failure的block
    [req invokeWithTarget:self success:^(NSURLSessionTask *task, NSDictionary *resp) {
        NSLog(@"版本检测%@",resp);
    }];
}


@end
