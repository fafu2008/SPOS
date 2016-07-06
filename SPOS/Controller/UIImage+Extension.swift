//
//  UIImage+Extention.swift
//  HUSliderMenu
//
//  Created by jewelz on 15/7/14.
//  Copyright (c) 2015年 yangtzeu. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1.0, height: 10), false, 0.0)
        
        color.set()
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 10))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func imageWithColors(colors : [UIColor] , size : CGSize) -> UIImage {
        
        var cgColors = [AnyObject]()
        for color in colors {
            cgColors.append(color.CGColor)
        }
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        let colorSpace = CGColorGetColorSpace(colors.last?.CGColor)
        let gradient = CGGradientCreateWithColors(colorSpace, cgColors, nil)
        CGContextDrawLinearGradient(context, gradient, CGPointMake(size.width/2, 0), CGPointMake(size.width/2, size.height), .DrawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        return image
        
    }
}
