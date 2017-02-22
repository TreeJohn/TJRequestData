//
//  NSString+Encrypt.h
//  MarryTask
//
//  Created by TreeJohn on 16/1/14.
//  Copyright © 2016年 Xianhenet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString *)base64Encode;

- (NSString *)base64Deconde;

- (NSString *)md5String;

- (id)parseJsonString;

+ (NSString*)stringFromJsonObject: (id)object;

@end
