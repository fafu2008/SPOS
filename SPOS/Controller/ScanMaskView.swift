//
//  ScanMaskView.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ScanMaskView: UIView {

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let width = SCREENWIDTH * 800 / 1242
        let left = SCREENWIDTH * (1242 - 800) / 1242 / 2
        
        let context:CGContext? = UIGraphicsGetCurrentContext()
        
        //非扫码区域半透明
        //设置非识别区域颜色
        CGContextSetRGBFillColor(context, 0, 0,
                                 0, 0.5)
        //填充矩形
        //扫码区域上面填充
        var rect = CGRectMake(0, 0, SCREENWIDTH, 124)
        CGContextFillRect(context, rect)
        
        //扫码区域左边填充
        rect = CGRectMake(0, 124, left , width)
        CGContextFillRect(context, rect)
        
        //扫码区域右边填充
        rect = CGRectMake(left + width, 124, left , width)
        CGContextFillRect(context, rect)
        
        //扫码区域下面填充
        rect = CGRectMake(0, 124 + width , SCREENWIDTH , SCREENHEIGHT - 124 - width)
        CGContextFillRect(context, rect)
        //执行绘画
        CGContextStrokePath(context)
    }
 
    //根据矩形区域，获取识别区域
    static func getScanRectWithPreView() -> CGRect
    {
        let sizeRetangle = CGSizeMake(SCREENWIDTH * 800 / 1242 , SCREENWIDTH * 800 / 1242)

        //扫码区域坐标
        let cropRect =  CGRectMake(SCREENWIDTH * (1242 - 800) / 1242 / 2 , 124, sizeRetangle.width , sizeRetangle.height)
        
        //计算兴趣区域
        var rectOfInterest:CGRect
        
        let size = CGSizeMake(SCREENWIDTH, SCREENHEIGHT)
        let p1 = size.height/size.width
        
        let p2:CGFloat = 1920.0/1080.0 //使用了1080p的图像输出
        if p1 < p2 {
            let fixHeight = size.width * 1920.0 / 1080.0;
            let fixPadding = (fixHeight - size.height)/2;
            rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                        cropRect.origin.x/size.width,
                                        cropRect.size.height/fixHeight,
                                        cropRect.size.width/size.width)
            
            
        } else {
            let fixWidth = size.height * 1080.0 / 1920.0;
            let fixPadding = (fixWidth - size.width)/2;
            rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                        (cropRect.origin.x + fixPadding)/fixWidth,
                                        cropRect.size.height/size.height,
                                        cropRect.size.width/fixWidth)
        }
        return rectOfInterest
    }

}
