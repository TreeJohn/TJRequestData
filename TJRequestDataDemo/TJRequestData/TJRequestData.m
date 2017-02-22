//
//  RequestData.m
//  MarryTask
//
//  Created by TreeJohn on 15/1/29.
//  Copyright (c) 2015年 TreeJohn. All rights reserved.
//

#import "TJRequestData.h"
#import "AFHTTPSessionManager.h"
#import "NSString+Encrypt.h"
#import "MMMaterialDesignSpinner.h"
#import "UIView+Toast.h"
#import "AFNetworkReachabilityManager.h"
#import "UIImage+Orientation.h"
#import "NSDictionary+Extend.h"

#define afTimeoutInterval 15
#define secretKey @"XIANHE1301"

#define SCRWIDTH [[UIScreen mainScreen]bounds].size.width
#define SCRHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface TJRequestData()

@property (nonatomic, strong) NSMutableDictionary *sendParam;   // finally sended parameters
@property (nonatomic, strong) MMMaterialDesignSpinner *materialview; // loading

@end

@implementation TJRequestData

@synthesize param,sendParam,materialview;

#pragma mark - Initialization

+ (instancetype)defaultRequestData
{
    TJRequestData *requestData = [TJRequestData new];
    requestData.param = [NSMutableDictionary new];
    [requestData setValue:[NSMutableDictionary new] forKey:@"sendParam"];
    
    return requestData;
}

+ (instancetype)defaultRequestDataWithServiceId: (NSString *)serviceId
{
    TJRequestData *requestData = [TJRequestData defaultRequestData];
    requestData.serviceId = serviceId;
    [requestData.sendParam setObject:serviceId forKey:@"serviceId"];
    
    return requestData;
}

- (void)setServiceId:(NSString *)serviceId
{
    _serviceId = serviceId;
    [self.sendParam setObject:_serviceId forKey:@"serviceId"];
}

#pragma mark - Invoke Request

-(void) invokeWithTarget: (UIViewController *) target
                 success:(void (^)(NSURLSessionTask *task, id responseObject))success
{
    [self invokeWithTarget:target success:success failure:nil];
}

-(void) invokeWithTarget: (UIViewController *) target
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success
                 failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{
    [self invokeWithTarget:target url:SERVER_URL success:success failure:failure];
}

-(void) invokeWithTarget: (UIViewController *) target
                     url: (NSString *) url
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success
                 failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{
     [self invokeWithTarget:target url:url useLoading:YES success:success failure:failure];
}


-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success
{
    [self invokeWithNoLoadingTarget:target success:success failure:nil];
}

-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success
                          failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{
    [self invokeWithNoLoadingTarget:target url:SERVER_URL success:success failure:failure];
}

-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                              url: (NSString *) url
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success
                          failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{
     [self invokeWithTarget:target url:url useLoading:NO success:success failure:failure];
}

-(void) invokeWithTarget: (UIViewController *) target
                     url: (NSString *) url
              useLoading: (BOOL) useLoading
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success
                 failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    
    target.view.userInteractionEnabled = NO;
    if (useLoading) {
        [self initMaterialview:target];
    }
    
    manager.requestSerializer.timeoutInterval = afTimeoutInterval;
    [sendParam setObject:[param toJsonString] forKey:@"data"];
    NSLog(@"发送参数 = %@",[sendParam toJsonString]);
    
    // do something about your own compony when request success
    void (^theSuccess) (NSURLSessionTask *task, id responseObject) = ^(NSURLSessionTask *task, NSDictionary *resp) {
        NSLog(@"\nserviceId: %@, \n返回参数 = %@", weakSelf.serviceId, [resp toJsonString]);
        
        NSInteger respCode = [resp[@"code"] integerValue];
        NSString *respMsg = resp[@"message"];
        
        if (respCode <= 10000) {
            success(task, resp);
        } else {
            // show user the error message
            [target.view makeToast:respMsg duration:1.0 position:@"center"];
            if (failure) {
                failure(task,nil);
            }
        }
        
        target.view.userInteractionEnabled = YES;
        if (useLoading) {
            [materialview stopAnimating];
            [materialview removeFromSuperview];
        }
    };
    
    // do something about your own compony when request faild
    void (^theFailure) (NSURLSessionTask *task, NSError *error) = ^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"error: %@", error);
        
        if (failure) {
            failure(task, error);
        } else {
            [target.view makeToast:@"啊哦，网络故障，再来一次!" duration:1.0 position:@"center"];
            
            target.view.userInteractionEnabled = YES;
            if (useLoading) {
                [materialview stopAnimating];
                [materialview removeFromSuperview];
            }
        }
    };
    
    [manager.operationQueue cancelAllOperations];
        
    [manager POST:url parameters:sendParam progress:NULL success:theSuccess failure:theFailure];
}

-(void) invokeUploadImageWithTarget: (UIViewController *) target
                              images:(NSArray<UIImage *>*)images
                            success: (void (^)(NSURLSessionTask *task, id responseObject))success
{
    [self invokeUploadImageWithTarget:target url:IMAGE_URL images:images useLoading:YES success:success failure:nil];
}

-(void) invokeUploadImageWithTarget: (UIViewController *) target
                                url: (NSString *) url
                              images:(NSArray<UIImage *>*)images
                         useLoading: (BOOL) useLoading
                            success: (void (^)(NSURLSessionTask *task, id responseObject))success
                            failure: (void (^)(NSURLSessionTask *task, NSError *error))failure
{

    NSLog(@"UploadImageparam>>>>>>%@",param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
    target.view.userInteractionEnabled = NO;
    if (useLoading) {
        [self initMaterialview:target];
    }
        manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject: url ? @"text/plain" : @"application/json"];
    
    // do something about your own compony when request success
    void (^theSuccess) (NSURLSessionTask *task, id responseObject) = ^(NSURLSessionTask *task, id responseObject) {

        NSLog(@"UploadImageesult>>>>>>%@",responseObject);
        
        target.view.userInteractionEnabled = YES;
        if (useLoading) {
            [materialview stopAnimating];
            [materialview removeFromSuperview];
        }
        success(task, responseObject);
    };
    
    // do something about your own compony when request faild
    void (^theFailure) (NSURLSessionTask *task, NSError *error) = ^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"error: %@", error);
        
        if (failure) {
            failure(task, error);
        } else {
            [target.view makeToast:@"啊哦，网络故障，再来一次!" duration:1.0 position:@"center"];
            
            target.view.userInteractionEnabled = YES;
            if (useLoading) {
                [materialview stopAnimating];
                [materialview removeFromSuperview];
            }
        }
    };
    
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage* image in images) {
            UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation([UIImage fixOrientation:image], 0.3) name:@"file" fileName:[NSString stringWithFormat:@"%@.png",[@(recordTime) stringValue]] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {

        NSLog(@"图片上传中...%.1f%%",uploadProgress.fractionCompleted);
        
    } success:theSuccess failure:theFailure];
}

#pragma mark - Private Methods

// 数据参数转码base64字符串
- (NSString *)getBase64Data
{
    return [[NSString stringFromJsonObject:param] base64Encode];
}

// 生成签名
- (NSString *)getSign
{
    NSString *base64Data = [self getBase64Data];
    NSString *result = [NSString stringWithFormat:@"%@%@", base64Data, secretKey];
    return [result md5String];
}

// 初始化Loading
- (void) initMaterialview: (UIViewController *)target
{
    materialview = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    materialview.lineWidth = 3.5f;
    materialview.tintColor = [UIColor colorWithRed:255/255. green:182/255. blue:199/255. alpha:1.];
    
    if ([target.view isKindOfClass:[UITableView class]]) {
        UITableView *talbeView = (UITableView *)target.view;
        CGPoint center = talbeView.center;
        if (center.y == SCRHEIGHT / 2) {
            materialview.center = CGPointMake(center.x, center.y - 64);
        } else {
            materialview.center = CGPointMake(center.x, center.y + talbeView.bounds.origin.y);
        }
    } else {
        materialview.center = CGPointMake(SCRWIDTH / 2, SCRHEIGHT * 0.9 / 2);
    }
    
    [target.view addSubview:materialview];
    [materialview startAnimating];
}

@end
