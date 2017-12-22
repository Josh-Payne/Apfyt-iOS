//
//  OpenCVHeader.h
//  Apfyt
//
//  Created by Josh Payne on 4/5/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

// This is a forward declaration; we cannot include *-Swift.h in a header.
@class ViewController;


@interface OpenCV : NSObject

/// Converts a full color image to grayscale image with using OpenCV.
+ (long)decode:(nonnull UIImage *)image;

@end
@interface OpenCV2 : NSObject

/// Converts a full color image to grayscale image with using OpenCV.
+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image;

@end
