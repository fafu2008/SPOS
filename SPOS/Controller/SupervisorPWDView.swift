//
//  SupervisorPWDView.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/5.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SupervisorPWDView: UIView,UITextFieldDelegate {

    var number = 6
    
    var aryTextFld:NSMutableArray?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        
        self.aryTextFld = NSMutableArray.init(capacity: 6)
        
    }
    
    func get_password()->String
    {
        var out_str = String("")
        
        for i in 0...5{
            if (self.aryTextFld![i].text.characters.count > 0)
            {
                let str : String = self.aryTextFld![i].text
                let index = str.startIndex.advancedBy(1)
                let sub_str = str.substringToIndex(index)
                out_str += sub_str
            }
        }
        
        return out_str
    }
    
    func textChanged(textField: UITextField)
    {
        if (textField.text?.characters.count > 0)
        {
            if (textField.tag < 6)
            {
                let tf = self.aryTextFld![textField.tag]
                tf.becomeFirstResponder()
            }
            else
            {
                textField.resignFirstResponder()
            }
        }
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
            
            if (i < 6)
            {
              let tf = UITextField.init(frame: CGRectMake((rect.size.width - 240) / 2 + CGFloat(i) * 40+10, 81, 20, 20))
              tf.tag = i+1
              tf.keyboardType = .NumberPad
              tf.textAlignment = .Center
              tf.secureTextEntry = true
              tf.delegate = self
              tf.addTarget(self, action: #selector(self.textChanged), forControlEvents:UIControlEvents.EditingChanged)
              self.addSubview(tf)
              self.aryTextFld!.addObject(tf)
            }
        }
        
        self.aryTextFld![0].becomeFirstResponder()
        
        CGContextStrokePath(context)
        
        /*
        for i in 0..<number{
            CGContextAddArc(context, (rect.size.width - 240) / 2 + 20 + 40 * CGFloat(i), 71 + 20, 10, 0, CGFloat(2 * M_PI), 0)
            
        }
        */
        
        CGContextFillPath(context)
        
        
        
    }
 
    
}
