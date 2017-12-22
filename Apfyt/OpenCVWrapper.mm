//
//  OpenCVWrapper.mm
//  Apfyt
//
//  Created by Josh Payne on 4/5/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

#include <iostream>
#include <stdio.h>
#include "OpenCV.h"
#import "UIImage+OpenCV.h"
#import "opencv2/videoio/cap_ios.h"
#include "opencv2/core.hpp"
#include "opencv2/core/utility.hpp"
#include "opencv2/core/ocl.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/features2d.hpp"
#include "opencv2/calib3d.hpp"
#include "opencv2/imgproc.hpp"

using namespace std;
using namespace cv;

int movementLeftX = 0;
int movementRightX = 0;
int movementLeftY = 0;
int movementRightY = 0;

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define PI 3.14159265

static void UIImageToMat(UIImage *image, cv::Mat &mat) {
    
    // Create a pixel buffer.
    NSInteger width = CGImageGetWidth(image.CGImage);
    NSInteger height = CGImageGetHeight(image.CGImage);
    CGImageRef imageRef = image.CGImage;
    cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Draw all pixels to the buffer.
    cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
    cv::cvtColor(mat8uc4, mat8uc3, CV_RGBA2BGR);
    mat = mat8uc3;
}

@implementation OpenCV

///// This returns the base 10 interpretation of an Apfyt code.

+ (long)decode:(nonnull UIImage *)image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat grayMat;
    cv::cvtColor(bgrMat, grayMat, CV_BGR2GRAY);
    //medianBlur(grayMat, grayMat, 15);
    //![reduce_noise]
    long hexInt = 0;
    std::vector<Vec3f> circles;
    std::vector<Vec3f> realCircles;
    /// Apply the Hough Transform to find the circles
    HoughCircles(grayMat, circles, CV_HOUGH_GRADIENT, 1, grayMat.rows/80, 100, 30, 7, 35); //3-12
    
    /// Find the extreme circles, check scancode validity
    double roughRadius = 0.0;
    double avgRadius = 0.0;
    int counter = 0;
    int extLeft = INT_MAX;
    int extRight = 0;
    int lC;
    int rC;
    Vec3f leftCircle;
    Vec3f rightCircle;
    int extHi = INT_MAX;
    int extLo = 0;
    int loC;
    int hiC;
    Vec3f loCircle;
    Vec3f hiCircle;
    for (size_t i = 0; i < circles.size(); i++) {
        roughRadius += cvRound(circles[i][2]);
    }
    roughRadius /= circles.size();
    int highColor = 0;
    int lowColor = INT_MAX;
    
    for (size_t i = 0; i < circles.size(); i++) {
        //        cv::Point centre;
        //        centre.x = circles[i][0];
        //        centre.y = circles[i][1];
        //        Scalar col = grayMat.at<uchar>(centre);
        
        //cout<<i<<": "<<col.val[0]<<endl;
        if (roughRadius*.8 < cvRound(circles[i][2]) < roughRadius*1.2) {
            if (grayMat.at<uchar>(circles[i][1], circles[i][0]) > highColor) {
                highColor = grayMat.at<uchar>(circles[i][1], circles[i][0]);
            }
            if (grayMat.at<uchar>(circles[i][1], circles[i][0]) < lowColor) {
                lowColor = grayMat.at<uchar>(circles[i][1], circles[i][0]);
            }
            avgRadius += cvRound(circles[i][2]);
            counter++;
            if (cvRound(circles[i][1]) < extLeft && grayMat.at<uchar>(circles[i][1], circles[i][0]) < 100) {
                extLeft = cvRound(circles[i][1]);
                lC = int(i);
                rightCircle = circles[i];
                
            }
            if (cvRound(circles[i][1]) > extRight && grayMat.at<uchar>(circles[i][1], circles[i][0]) < 100) {
                extRight = cvRound(circles[i][1]);
                rC = int(i);
                leftCircle = circles[i];
            }
            if (cvRound(circles[i][0]) > extLo) {
                extLo = cvRound(circles[i][0]);
                loC = int(i);
                loCircle = circles[i];
            }
            if (cvRound(circles[i][0]) < extHi) {
                extHi = cvRound(circles[i][0]);
                hiC = int(i);
                hiCircle = circles[i];
            }
        }
    }
    
    
    // cout<<avgColor<<endl;
    if (counter != 0) {
        avgRadius /= counter;
    }
    
    
    
    double yDim = leftCircle[0] - rightCircle[0];
    double xDim = leftCircle[1] - rightCircle[1];
    
    Scalar color;
    String binary = "";
    
    double theta = atan((yDim/2)/(xDim/2)) * (180/PI);
    double cosTheta = cos(theta*PI/180);
    
    double adjacent6 = sqrt((avgRadius * avgRadius * 36)-(cosTheta * cosTheta * avgRadius * avgRadius * 36));
    double adjacent4 = sqrt((avgRadius * avgRadius * 16)-(cosTheta * cosTheta * avgRadius * avgRadius * 16));
    double adjacent2 = sqrt((avgRadius * avgRadius * 4) -(cosTheta * cosTheta * avgRadius * avgRadius * 4));
    
    if (leftCircle[0] < rightCircle[0]) {
        adjacent6*=-1;
        adjacent4*=-1;
        adjacent2*=-1;
    }
    
    Vec3f higherCircle;
    if (leftCircle[0]<rightCircle[0]) {
        higherCircle = leftCircle;
    } else higherCircle = rightCircle;
    Vec3f lowerCircle;
    if (leftCircle[0]>rightCircle[0]) {
        lowerCircle = leftCircle;
    } else lowerCircle = rightCircle;
    
    if (avgRadius*2*9.60 < sqrt((yDim)*(yDim) + (xDim)*(xDim)) && sqrt((yDim)*(yDim) + (xDim)*(xDim)) < avgRadius*2*11.8) {
        cv::Point cen;
        cen.y = cvRound((leftCircle[1]) - ((xDim/9)*3) - (xDim/18) + adjacent2);
        cen.x = cvRound(leftCircle[0] + avgRadius/5 - (cosTheta*(avgRadius * 2) + (yDim/9)*3));
        highColor = grayMat.at<uchar>(cen);
        int avgColor = (highColor+lowColor)/2;
        
        ///Top layer
        for (int i = 1; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent6);
            cen.x = cvRound(leftCircle[0] + avgRadius/3 - (cosTheta*(avgRadius * 6) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            //cout<<color<<endl;
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
            
        }
        ///Midtop Layer
        for (int i = 0; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/9) + adjacent4);
            cen.x = cvRound(leftCircle[0] + avgRadius/4 - (cosTheta*(avgRadius * 4) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Up Midleft
        for (int i = 0; i < 2; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent2);
            cen.x = cvRound(leftCircle[0] + avgRadius/5 - (cosTheta*(avgRadius * 2) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Up Midright
        for (int i = 7; i < 9; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent2);
            cen.x = cvRound(leftCircle[0] + avgRadius/5 - (cosTheta*(avgRadius * 2) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///left
        cen.y = cvRound(leftCircle[1] - xDim/9);
        cen.x = cvRound(leftCircle[0] - yDim/9);
        color = grayMat.at<uchar>(cen);
        if (color.val[0] < avgColor) {
            binary += "1";
        }
        else binary += "0";
        ///right
        cen.y = cvRound((leftCircle[1]) - ((xDim/9)*8));
        cen.x = cvRound(leftCircle[0] - yDim/9*8);
        color = grayMat.at<uchar>(cen);
        if (color.val[0] < avgColor) {
            binary += "1";
        }
        else binary += "0";
        ///Down Midleft
        for (int i = 0; i < 2; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent2);
            cen.x = cvRound(leftCircle[0] - avgRadius/5 + (cosTheta*(avgRadius * 2) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Down Midright
        for (int i = 7; i < 9; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent2);
            cen.x = cvRound(leftCircle[0] - avgRadius/5 + (cosTheta*(avgRadius * 2) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Midbottom Layer
        for (int i = 0; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/9) - adjacent4);
            cen.x = cvRound(leftCircle[0] - avgRadius/4 + (cosTheta*(avgRadius * 4) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Bottom layer
        for (int i = 1; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent6);
            cen.x = cvRound(leftCircle[0] - avgRadius/3 + (cosTheta*(avgRadius * 6) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
    }
    cout<<binary<<endl;
    //return hexInt;
    hexInt=0;
    int len = int(binary.size());
    for (int i=0;i<len;i++) {
        hexInt+=( binary[len-i-1]-48) * pow(2,i);
    }
    return hexInt;
}

@end
/// Converts a Mat to UIImage.
static UIImage *MatToUIImage(cv::Mat &mat) {
    
    // Create a pixel buffer.
    assert(mat.elemSize() == 1 || mat.elemSize() == 3);
    cv::Mat matrgb;
    if (mat.elemSize() == 1) {
        cv::cvtColor(mat, matrgb, CV_GRAY2RGB);
    } else if (mat.elemSize() == 3) {
        cv::cvtColor(mat, matrgb, CV_BGR2RGB);
    }
    
    // Change an image format.
    NSData *data = [NSData dataWithBytes:matrgb.data length:(matrgb.elemSize() * matrgb.total())];
    CGColorSpaceRef colorSpace;
    if (matrgb.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(matrgb.cols, matrgb.rows, 8, 8 * matrgb.elemSize(), matrgb.step.p[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

/// Restore the orientation to image.
static UIImage *RestoreUIImageOrientation(UIImage *processed, UIImage *original) {
    if (processed.imageOrientation == original.imageOrientation) {
        return processed;
    }
    return [UIImage imageWithCGImage:processed.CGImage scale:1.0 orientation:original.imageOrientation];
}

@implementation OpenCV2


///// This returns an image - used for debugging purposes only.
+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat grayMat;
    cv::cvtColor(bgrMat, grayMat, CV_BGR2GRAY);
    //medianBlur(grayMat, grayMat, 15);
    //![reduce_noise]
    long hexInt = 0;
    std::vector<Vec3f> circles;
    std::vector<Vec3f> realCircles;
    /// Apply the Hough Transform to find the circles
    HoughCircles(grayMat, circles, CV_HOUGH_GRADIENT, 1, grayMat.rows/80, 100, 30, 5, 35);
    
    /// Find the extreme circles, check scancode validity
    double roughRadius = 0.0;
    double avgRadius = 0.0;
    int counter = 0;
    int extLeft = INT_MAX;
    int extRight = 0;
    int lC;
    int rC;
    Vec3f leftCircle;
    Vec3f rightCircle;
    int extHi = INT_MAX;
    int extLo = 0;
    int hiC;
    int loC;
    Vec3f hiCircle;
    Vec3f loCircle;
    for (size_t i = 0; i < circles.size(); i++) {
        roughRadius += cvRound(circles[i][2]);
    }
    roughRadius /= circles.size();
    int highColor=0;
    int lowColor = INT_MAX;
    for (size_t i = 0; i < circles.size(); i++) {
        
        if (roughRadius*.8 < cvRound(circles[i][2]) < roughRadius*1.2) {
            
            if (grayMat.at<uchar>(circles[i][1], circles[i][0]) > highColor) {
                highColor = grayMat.at<uchar>(circles[i][1], circles[i][0]);
            }
            if (grayMat.at<uchar>(circles[i][1], circles[i][0]) < lowColor) {
                lowColor = grayMat.at<uchar>(circles[i][1], circles[i][0]);
            }
            
            if (roughRadius*.8 < cvRound(circles[i][2]) < roughRadius*1.2) {
                avgRadius += cvRound(circles[i][2]);
                counter++;
            }
            if (cvRound(circles[i][1]) < extLeft && grayMat.at<uchar>(circles[i][1], circles[i][0]) < 100) {
                extLeft = cvRound(circles[i][1]);
                lC = int(i);
                rightCircle = circles[i];
                
            }
            if (cvRound(circles[i][1]) > extRight && grayMat.at<uchar>(circles[i][1], circles[i][0]) < 100) {
                extRight = cvRound(circles[i][1]);
                rC = int(i);
                leftCircle = circles[i];
            }
            if (cvRound(circles[i][0]) > extLo) {
                extLo = cvRound(circles[i][0]);
                loC = int(i);
                loCircle = circles[i];
            }
            if (cvRound(circles[i][0]) < extHi) {
                extHi = cvRound(circles[i][0]);
                hiC = int(i);
                hiCircle = circles[i];
            }
        }
    }
    
    int avgColor = (highColor+lowColor)/2;
    
    if (counter != 0) {
        avgRadius /= counter;
    }
    
    circle(grayMat, cv::Point(hiCircle[0],hiCircle[1]), 3, Scalar(0,255,0), -1, 8, 0 );
    
    double yDim = leftCircle[0] - rightCircle[0];
    double xDim = leftCircle[1] - rightCircle[1];
    
    Scalar color;
    String binary = "";
    //std::cout<<"Check"<<std::endl;
    ///if it is a scan code
    double theta = atan((yDim/2)/(xDim/2)) * (180/PI);
    double cosTheta = cos(theta*PI/180);
    
    double adjacent6 = sqrt((avgRadius * avgRadius * 36)-(cosTheta * cosTheta * avgRadius * avgRadius * 36));
    double adjacent4 = sqrt((avgRadius * avgRadius * 16)-(cosTheta * cosTheta * avgRadius * avgRadius * 16));
    double adjacent2 = sqrt((avgRadius * avgRadius * 4) -(cosTheta * cosTheta * avgRadius * avgRadius * 4));
    if (leftCircle[0] < rightCircle[0]) {
        adjacent6*=-1;
        adjacent4*=-1;
        adjacent2*=-1;
    }
    
    Vec3f higherCircle;
    if (leftCircle[0]<rightCircle[0]) {
        higherCircle = leftCircle;
    } else higherCircle = rightCircle;
    Vec3f lowerCircle;
    if (leftCircle[0]>rightCircle[0]) {
        lowerCircle = leftCircle;
    } else lowerCircle = rightCircle;
    
    if (avgRadius*2*9.60 < sqrt((yDim)*(yDim) + (xDim)*(xDim)) && sqrt((yDim)*(yDim) + (xDim)*(xDim)) < avgRadius*2*11.8 && abs(yDim) < 60) {
        cv::Point cen;
        ///Top layer
        for (int i = 1; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent6);
            cen.x = cvRound(leftCircle[0] + avgRadius/3 - (cosTheta*(avgRadius * 6) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
            
        }
        ///Midtop Layer
        for (int i = 0; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/9) + adjacent4);
            cen.x = cvRound(leftCircle[0] + avgRadius/4 - (cosTheta*(avgRadius * 4) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Up Midleft
        for (int i = 0; i < 2; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent2);
            cen.x = cvRound(leftCircle[0] + avgRadius/5 - (cosTheta*(avgRadius * 2) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Up Midright
        for (int i = 7; i < 9; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) + adjacent2);
            cen.x = cvRound(leftCircle[0] + avgRadius/5 - (cosTheta*(avgRadius * 2) + (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///left
        cen.y = cvRound(leftCircle[1] - xDim/9);
        cen.x = cvRound(leftCircle[0] - yDim/9);
        if (color.val[0] < avgColor) {
            binary += "1";
        }
        else binary += "0";
        ///right
        cen.y = cvRound((leftCircle[1]) - ((xDim/9)*8));
        cen.x = cvRound(leftCircle[0] - yDim/9*8);
        color = grayMat.at<uchar>(cen);
        if (color.val[0] < avgColor) {
            binary += "1";
        }
        else binary += "0";
        ///Down Midleft
        for (int i = 0; i < 2; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent2);
            cen.x = cvRound(leftCircle[0] - avgRadius/5 + (cosTheta*(avgRadius * 2) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Down Midright
        for (int i = 7; i < 9; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent2);
            cen.x = cvRound(leftCircle[0] - avgRadius/5 + (cosTheta*(avgRadius * 2) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Midbottom Layer
        for (int i = 0; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/9) - adjacent4);
            cen.x = cvRound(leftCircle[0] - avgRadius/4 + (cosTheta*(avgRadius * 4) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        ///Bottom layer
        for (int i = 1; i < 8; i++) {
            cen.y = cvRound((leftCircle[1]) - ((xDim/9)*i) - (xDim/18) - adjacent6);
            cen.x = cvRound(leftCircle[0] - avgRadius/3 + (cosTheta*(avgRadius * 6) - (yDim/9)*i));
            color = grayMat.at<uchar>(cen);
            if (color.val[0] < avgColor) {
                binary += "1";
            }
            else binary += "0";
        }
        cout<<binary<<endl;
    }
    
    //return hexInt;
    hexInt=0;
    int len = int(binary.size());
    for (int i=0;i<len;i++) {
        hexInt+=( binary[len-i-1]-48) * pow(2,i);
    }
    UIImage *grayImage = MatToUIImage(grayMat);
    return RestoreUIImageOrientation(grayImage, image);
}

@end
