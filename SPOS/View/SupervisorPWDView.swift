//
//  SupervisorPWDView.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/5.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SupervisorPWDView: UIView {

    var number = 6
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        
        
        
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor)
        CGContextMoveToPoint(context, 0, rect.size.height - 44)
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 44)
        
        CGContextMoveToPoint(context, rect.size.width/2, rect.size.height - 44)
        CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height)
        
        CGContextMoveToPoint(context, (rect.size.width - 240) / 2, 71)
        CGContextAddLineToPoint(context, (rect.size.width - 240) / 2 + 240, 71)
        
        CGContextMoveToPoint(context, (rect.size.width - 240) / 2, 111)
        CGContextAddLineToPoint(context, (rect.size.width - 240) / 2 + 240, 111)
        
        for i in 0...6 {
            CGContextMoveToPoint(context, (rect.size.width - 240) / 2 + CGFloat(i) * 40, 71)
            CGContextAddLineToPoint(context, (rect.size.width - 240) / 2 + CGFloat(i) * 40, 111)
        }
        
        CGContextStrokePath(context)
        
        for i in 0..<number{
            CGContextAddArc(context, (rect.size.width - 240) / 2 + 20 + 40 * CGFloat(i), 71 + 20, 10, 0, CGFloat(2 * M_PI), 0)
            
        }
        
        CGContextFillPath(context)
        
        
        
    }
 

}
