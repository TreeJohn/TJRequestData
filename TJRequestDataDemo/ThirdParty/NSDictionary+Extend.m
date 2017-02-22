//
//  NSDictionary+Extend.m
//  YiDao
//
//  Created by TreeJohn on 16/6/7.
//  Copyright © 2016年 XiaoFanChuan. All rights reserved.
//

#import "NSDictionary+Extend.h"

@implementation NSDictionary(Extend)

-(BOOL) isRequestSuccess
{
    if (!self) {
        return NO;
    }
    if (!self[@"code"]) {
        return NO;
    }
    return [self[@"code"] integerValue] == 0;
}

-(NSString *)toJsonString
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
