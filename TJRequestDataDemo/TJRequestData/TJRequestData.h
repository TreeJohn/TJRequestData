//
//  RequestData.h
//  MarryTask
//
//  Created by TreeJohn on 15/1/29.
//  Copyright (c) 2015年 TreeJohn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if DEBUG // test production environment

#define SERVER_DOMAIN  @"http://yidao.hunmi.org"

#else // production environment

#define SERVER_DOMAIN  @"http://yidao.hunmi.org"

#endif

#define SERVER_URL SERVER_DOMAIN@"/hunmi-app/app"                                   // API
#define IMAGE_URL SERVER_DOMAIN@"/HunParUpload/uploadServletDemo"                   // image url


@interface TJRequestData : NSObject

@property (nonatomic, strong) NSString *serviceId;              // service id
@property (nonatomic, strong) NSMutableDictionary *param;       // service parameters KV

#pragma mark - Initialization

+ (instancetype)defaultRequestData;
+ (instancetype)defaultRequestDataWithServiceId: (NSString *)serviceId;

#pragma mark - Default Url

/** Invote the request with the controller target, you need to deal with success block
 *
 * @param target The view controller the request come from
 * @param success A block which you need to deal when request success
 */
-(void) invokeWithTarget: (UIViewController *) target
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success;

/** Invote the request with the controller target, you need to deal with success block and failure block
 *
 * @param target The view controller the request come from
 * @param failure A block which you need to deal when request failure, if nil show the default error toask
 */
-(void) invokeWithTarget: (UIViewController *) target
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success
                 failure: (void (^)(NSURLSessionTask *task, NSError *error))failure;

/** Invote the request with no loading view
 *
 * @param target The view controller the request come from
 * @param success A block which you need to deal when request success
 */
-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success;

/** Invote the request with no loading view
 *
 * @param target The view controller the request come from
 * @param failure A block which you need to deal when request failure, if nil show the default error toask
 */
-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success
                          failure: (void (^)(NSURLSessionTask *task, NSError *error))failure;

#pragma mark - Special Url

/** Invote the request with the controller target and the request url, you need to deal with success block and failure block
 *
 * @param target The view controller the request come from
 * @param url The request url
 * @param success A block which you need to deal when request success
 * @param failure A block which you need to deal when request failure
 */
-(void) invokeWithTarget: (UIViewController *) target
                     url: (NSString *) url
                 success: (void (^)(NSURLSessionTask *task, id responseObject))success
                 failure: (void (^)(NSURLSessionTask *task, NSError *error))failure;

/** Invote the request with no loading view
 *
 * @param target The view controller the request come from
 * @param url The request url
 * @param success A block which you need to deal when request success
 * @param failure A block which you need to deal when request failure
 */
-(void) invokeWithNoLoadingTarget: (UIViewController *) target
                              url: (NSString *) url
                          success: (void (^)(NSURLSessionTask *task, id responseObject))success
                          failure: (void (^)(NSURLSessionTask *task, NSError *error))failure;

/** Invote the request with uploading image
 *
 * @param target The view controller the request come from
 * @param images The image binary
 * @param success A block which you need to deal when request success
 */
-(void) invokeUploadImageWithTarget: (UIViewController *) target
                              images:(NSArray<UIImage *>*)images
                            success: (void (^)(NSURLSessionTask *task, id responseObject))success;


@end
