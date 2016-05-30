//
//  UIImage+FYImageCategory_h.h
//  
//
//  Created by 寿煜宇 on 16/5/30.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (FYImageCategory_h)

/** 设置图片圆角 */
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

/** 自定义图片大小 */
-(UIImage*) setOriginImage:(UIImage *)image scaleToSize:(CGSize)size;
/** 生成颜色图片 */
-(UIImage*) setOriginColor:(UIColor *)color scaleToSize:(CGSize)size;

@end
