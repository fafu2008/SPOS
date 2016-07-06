//
//  CustomBadge.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/23.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class CustomBadge: UIView {
    
    var badgeText : String = ""
    var badgeTextColor : UIColor = UIColor.whiteColor()
    var badgeInsetColor : UIColor = UIColor.redColor()
    var badgeFrameColor : UIColor = UIColor.redColor()
    
    var badgeFrame : Bool = false
    var badgeShining : Bool = false
    
    var badgeCornerRoundness : Float = 0.4
    var badgeScaleFactor : Float = 1.0
    
    
    convenience init(frame: CGRect , badgeText : String) {
        let width = badgeText == "0" ? 10 : 30
        self.init(frame: CGRectMake(0, 0, CGFloat(width), CGFloat(width)))
        self.badgeText = badgeText
        
    }
    
    
    convenience init(frame: CGRect ,badgeText : String , badgeTextColor : UIColor , badgeInsetColor : UIColor , badgeFrameColor : UIColor , badgeFrame : Bool , badgeShining : Bool) {
        self.init(frame : frame)
    }
    
    func autoBadgeSizeWithString(badgeString : String){
        if badgeString != "0" {
            var retValue = CGSizeZero
            let stringSize = (badgeString as NSString).sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12)])
            if badgeString.characters.count >= 2 {
                retValue = CGSizeMake((30 + stringSize.width + CGFloat(badgeString.characters.count)) * CGFloat(badgeScaleFactor), 30 * CGFloat(badgeScaleFactor))
            }else{
                retValue = CGSizeMake(30  * CGFloat(badgeScaleFactor), 30  * CGFloat(badgeScaleFactor))
            }
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height)
            badgeText = badgeString
        }
        
        setNeedsDisplay()
    }
    
    private func drawRoundRectWithContext(context : CGContext , rect : CGRect) {
        CGContextSaveGState(context)
        let radius = CGRectGetMaxY(rect) * CGFloat(badgeCornerRoundness)
        let puffer = CGRectGetMaxY(rect) * 0.1
        let maxX = CGRectGetMaxX(rect) - puffer
        let maxY = CGRectGetMaxY(rect) - puffer
        let minX = CGRectGetMidX(rect) - puffer
        let minY = CGRectGetMinY(rect) - puffer
        
        CGContextBeginPath(context)
        CGContextSetFillColorWithColor(context, badgeInsetColor.CGColor)
        CGContextAddArc(context, maxX - radius, minY + radius, radius, CGFloat(M_PI + M_PI/2), 0, 0)
        CGContextAddArc(context, maxX - radius, maxY - radius, radius, 0, CGFloat(M_PI/2), 0)
        CGContextAddArc(context, minX + radius, maxY - radius, radius, CGFloat(M_PI), CGFloat(M_PI * 1.5), 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
        
        
    }
    

    override func drawRect(rect: CGRect) {
       
        let context = UIGraphicsGetCurrentContext()
        drawRoundRectWithContext(context!, rect: rect)
        if badgeText.characters.count > 0 && badgeText != "0" {
            badgeTextColor.set()
            var sizeOfFont = 13.5 * badgeScaleFactor
            if badgeText.characters.count < 2 {
                sizeOfFont *= 1.2
            }
            let textFont = UIFont.boldSystemFontOfSize(CGFloat(sizeOfFont))
            let textSize = (badgeText as NSString).sizeWithAttributes([NSFontAttributeName : textFont])
            (badgeText as NSString).drawAtPoint(CGPointMake((rect.size.width / 2 - textSize.width / 2), (rect.size.height / 2 - textSize.height / 2)), withAttributes: [NSFontAttributeName : textFont , NSForegroundColorAttributeName : UIColor.whiteColor()])
            
            
            
        }
    }
    

}
