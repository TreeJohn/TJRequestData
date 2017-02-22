//
//  UIImage+Orientation.h
//  MarryArtisan
//
//  Created by kong on 16/5/12.
//  Copyright © 2016年 孔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

/**
 *  解决图片上传旋转的问题
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *  比率缩放
 *
 *  @param scaleSize <#scaleSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageToScale:(float)scaleSize;

@end
