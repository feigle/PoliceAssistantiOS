//
//  UIImage+LHDTools.m
//  刘和东
//
//  Created by 秦沙沙 on 2014/12/24.
//  Copyright © 2014年 刘和东. All rights reserved.
//

#import "UIImage+LHDTools.h"

@implementation UIImage (LHDTools)

/**把图片不压缩的转成NSData*/
- (NSData *)image2Data
{
    return [self pressImage2DataWithScale:1];
}

/**返回压之后的NSData，这里没有缩放，只是像素压缩*/
- (NSData *)pressImage2DataWithScale:(CGFloat)scale
{
    NSData *d = UIImageJPEGRepresentation(self, scale);
    if (!d) {
        d = UIImagePNGRepresentation(self);
    }
    return d;
}

/**返回压之后的image，这里没有缩放，只是像素压缩*/
- (UIImage *)pressImageWithScale:(CGFloat)scale
{
    return [UIImage imageWithData:[self pressImage2DataWithScale:scale]];
}

/**返回压之后的image，这里是对长宽压缩，像素无压缩*/
- (UIImage *)resizeImageWithScale:(CGFloat)scale
{
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    NSInteger width = imageWidth*scale;
    NSInteger height = imageHeight*scale;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

/**返回压之后的NSData，这里是对长宽压缩，像素无压缩*/
- (NSData *)resizeImage2DataWithScale:(CGFloat)scale
{
    return [[self resizeImageWithScale:scale] image2Data];
}

/**返回压之后的NSData，这里是对长宽、像素同时压缩*/
- (NSData *)resizePressImage2DataScale:(CGFloat)scale
{
    return [[self resizeImageWithScale:scale] pressImage2DataWithScale:scale];
}

/**返回压之后的UIImage，这里是对长宽、像素同时压缩*/
- (UIImage *)resizePressImageScale:(CGFloat)scale
{
    return [[self resizeImageWithScale:scale] pressImageWithScale:scale];
}

/**获取启动图片*/
+ (UIImage *)getLaunchImage
{
    NSString * viewOrientation = @"Portrait";
    static NSString * launchImage = nil;
    if (!launchImage) {
        NSArray * imagesDict = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"UILaunchImages"];
        for (NSDictionary * dict in imagesDict) {
            CGSize  imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, kScreenBounds.size)&& [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
                launchImage = dict[@"UILaunchImageName"];
            }
        }
    }
    return [UIImage imageNamed:launchImage];
}

/**获取appIcon图片*/
+ (UIImage *)getAppIconImage
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    return [UIImage imageNamed:iconLastName];
}

/**纠正图片*/
- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    return imageSize;
}

/**检测图片中的人脸数*/
- (NSArray *)detectionFeatures
{
    CIImage* image = [CIImage imageWithCGImage:self.CGImage];
    
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //得到面部数据
    NSArray* features = [detector featuresInImage:image];
    return features;
}
/**检测图片中是否有人脸*/
- (BOOL)detectionContainFeature
{
    NSArray * features = [self detectionFeatures];
    if (features.count > 0) {
        return YES;
    }
    return NO;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressToMaxDataSizeKBytes:(CGFloat)size
{
    NSData * data = UIImageJPEGRepresentation(self, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    while (dataKBytes > size && maxQuality > 0.1f) {
        maxQuality -= 0.02f;
        data = [self resizePressImage2DataScale:maxQuality];
        dataKBytes = data.length/1000.0;
    }
    return data;
}

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size{
    
    CGRect rect=CGRectMake(0.0f,0.0f,size.width,size.height);UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size radius:(NSInteger)radius
{
    
    UIImage * orImage = [[self class] createImageWithColor:color size:size];
    UIGraphicsBeginImageContext(orImage.size);
    
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    
    float y1 = 0.;
    
    float x2 = x1+orImage.size.width;
    
    float y2 = y1;
    
    float x3 = x2;
    
    float y3 = y1+orImage.size.height;
    
    float x4 = x1;
    
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    CGContextClosePath(gc);
    
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    
    CGContextScaleCTM(gc, 1, -1);
    
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimage;
    
}

@end
