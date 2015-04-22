//
//  UIImage+Additions.m
//  Aelo
//
//  Created by Xu Xiaojiang on 30/8/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "UIImage+Additions.h"
#import <objc/runtime.h>

@implementation UIImage (Additions)

+ (void)load {
  if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
       ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
    method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                   class_getClassMethod(self, @selector(imageNamedH568:)));
  }
}

+ (UIImage *)imageNamedH568:(NSString *)imageName {
  
  NSMutableString *imageNameMutable = [imageName mutableCopy];
  
  //Delete png extension
  NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
  if (extension.location != NSNotFound) {
    [imageNameMutable deleteCharactersInRange:extension];
  }
  
  //Look for @2x to introduce -568h string
  NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
  if (retinaAtSymbol.location != NSNotFound) {
    [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
  } else {
    [imageNameMutable appendString:@"-568h@2x"];
  }
  
  //Check if the image exists and load the new 568 if so or the original name if not
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
  if (imagePath) {
    //Remove the @2x to load with the correct scale 2.0
    [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
    return [UIImage imageNamedH568:imageNameMutable];
  } else {
    return [UIImage imageNamedH568:imageName];
  }
}



- (UIImage *)scaleToSize:(CGSize)size
{
  //Don't upscale smaller images
  if (self.size.width < size.width && self.size.height < size.height)
    return self;
  
  // Create a bitmap graphics context
  // This will also set it as the current context
  UIGraphicsBeginImageContext(size);
  
  // Draw the scaled image in the current context
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  
  // Create a new image from current context
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // Pop the current context from the stack
  UIGraphicsEndImageContext();
  
  // Return our new scaled image
  return scaledImage;
}

- (UIImage *)scaleToWidth:(CGFloat)width
{
    CGSize scaledSize = CGSizeMake(width, width * self.size.height / self.size.width);
    return [self scaleToSize:scaledSize];
}

- (UIImage *)crop:(CGRect)rect
{  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

- (UIImage *)squareCrop
{
  CGFloat size = MIN(self.size.width, self.size.height);
  CGRect rect = CGRectMake(self.size.width/2 - size/2,
                           self.size.height/2 - size/2,
                           size, size);
  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

- (UIImage *)resizableImageWithStandardInsets
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
        UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2-1, self.size.width/2-1);
        return [self resizableImageWithCapInsets:edgeInset];
    }
    
    //Support for 4.3
    return [self stretchableImageWithLeftCapWidth:self.size.width/2-1 topCapHeight:self.size.height/2-1];
}


#pragma mark - 

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage *)convertToGrayscale
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGSize size = [self size];
    int width = size.width *scale;
    int height = size.height *scale;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)hueAdjust:(CGFloat)hueAdjust
{
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter * controlsFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    [controlsFilter setValue:inputImage forKey:kCIInputImageKey];
    [controlsFilter setValue:@(hueAdjust) forKey:@"inputAngle"];
    
    CIImage *displayImage = controlsFilter.outputImage;
    UIImage *finalImage = [UIImage imageWithCIImage:displayImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // We did not get output image. Let's display the original image itself.
    if (displayImage == nil || finalImage == nil)
        return self;
    
    // We got output image. Display it.
    return [UIImage imageWithCGImage:[context createCGImage:displayImage fromRect:displayImage.extent]];
}

- (UIImage *)changeColor:(UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, [[UIScreen mainScreen] scale]);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [self size];
    
    // Retrieve source image and begin image context
    CGSize itemImageSize = [self size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [self CGImage]);
    // Fill and end the transparency layer
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(color.CGColor);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    const CGFloat* colors = CGColorGetComponents(color.CGColor);
    
    if(model == kCGColorSpaceModelMonochrome)
    {
        CGContextSetRGBFillColor(c, colors[0], colors[0], colors[0], colors[1]);
    }else{
        CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], colors[3]);
    }
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//+ (UIImage *)imageNamed:(NSString *)imageNamed withThemeName:(NSString *)themeName
//{
//    //No theme
//    if ([themeName length] <= 0)
//        return [[self class] imageNamed:imageNamed];
//    
//    //Disable/enable theme setting
//    BOOL enableTheme = [[BaseStorageManager sharedInstance] getSettingBOOLValueWithKey:SETTINGS_ENABLE_COLOR_THEME
//                                                                          defaultValue:SETTINGS_ENABLE_COLOR_THEME_DEFAULT];
//    if (enableTheme == NO)
//        return [[self class] imageNamed:imageNamed];
//    
//    BOOL hexColor = [themeName length] >= 4 && [themeName length] <=7 && [themeName contains:@"#"];
//    BOOL hueShift = !hexColor && [themeName length] < 3 && [themeName floatValue] >= 0 && [themeName floatValue] <= 360;
//    UIImage * adjustedImage = nil;
//    
//    //Apply different kind of theme hanlding
//    if (hexColor) {
//        UIImage * originalImage = [[self class] imageNamed:imageNamed];
//        UIColor * colorize = [UIColor colorWithHexString:themeName];
//        adjustedImage = [originalImage changeColor:colorize];
//    }
//    else if (hueShift) {
//        UIImage * originalImage = [[self class] imageNamed:imageNamed];
//        adjustedImage = [originalImage hueAdjust:[themeName floatValue]];
//    }
//    else {
//        NSString * adjustedImageNamed = imageNamed;
//        if ([themeName hasPrefix:@"_"])     adjustedImageNamed = [NSString stringWithFormat:@"%@%@", imageNamed, themeName];
//        else                                adjustedImageNamed = [NSString stringWithFormat:@"%@_%@", imageNamed, themeName];
//        adjustedImage = [[self class] imageNamed:adjustedImageNamed];
//        if (adjustedImage == nil)
//            adjustedImage = [[self class] imageNamed:imageNamed];
//    }
//    
//    return adjustedImage;
//}

+ (NSString *)correctImageNameByScrennResolutionImageName:(NSString *)imageName isIcon:(BOOL)isIcon
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (isIcon && [UIScreen mainScreen].scale == 2.f) {
        return [NSString stringWithFormat:@"%@@2x", imageName];
    }else if(isIcon && [UIScreen mainScreen].scale != 2.f){
        return [NSString stringWithFormat:@"%@", imageName];
    }
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        return [NSString stringWithFormat:@"%@-568h", imageName];
    } else if([UIScreen mainScreen].scale == 2.f) {
        return [NSString stringWithFormat:@"%@@2x", imageName];
    }
    
    return [NSString stringWithFormat:@"%@", imageName];
}

+ (UIImage *)oneTimeImageWithImageName:(NSString *)imageName isIcon:(BOOL)isIcon{
    NSString *correctedImageName = [UIImage correctImageNameByScrennResolutionImageName:imageName isIcon:isIcon];
    NSString *thePath = [[NSBundle mainBundle] pathForResource:correctedImageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:thePath];
}

@end
