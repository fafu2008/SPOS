//
//  TentacleView.swift
//  GesturePassword4Swift
//
//  Created by feiin on 14/11/22.
//  Copyright (c) 2014 year swiftmi. All rights reserved.
//

import UIKit


protocol ResetDelegate
{
    func resetPassword(result:String) -> Bool
    func isfirstPassword(result:String) ->Bool
}

protocol VerificationDelegate
{
    func verification(result:String) -> Bool
}

protocol TouchBeginDelegate{
    
    func gestureTouchBegin()
}

class TentacleView: UIView {

    var buttonArray:[GesturePasswordButton]=[]
    var touchesArray:[Dictionary<String,Float>]=[]
    var touchedArray:[String] = []
    
    
    var lineStartPoint:CGPoint?
    var lineEndPoint:CGPoint?
    
    var rerificationDelegate:VerificationDelegate?
    var resetDelegate:ResetDelegate?
    var touchBeginDelegate:TouchBeginDelegate?
    
    var style:Int?
    
    var success:Bool = false
    var drawed:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        success = true
    }

    required init?(coder aDecoder: NSCoder) {
       
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        var touchPoint:CGPoint
        let touch:UITouch? = touches.first! as UITouch
        
        touchesArray.removeAll()
        touchedArray.removeAll()
        
        touchBeginDelegate!.gestureTouchBegin()
        
       
        success = true
        drawed = false
        
        if(touch != nil){
            
            
            touchPoint = touch!.locationInView(self)
            
            
            for(var i=0;i<buttonArray.count;i++){
                
                let buttonTemp = buttonArray[i]
                buttonTemp.success = true
                buttonTemp.selected = false
                
                if(CGRectContainsPoint(buttonTemp.frame,touchPoint)){
                    let frameTemp = buttonTemp.frame
                    let point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2)
                    
                    var dict:Dictionary<String,Float> = [:]
                    dict["x"] = Float(point.x)
                    dict["y"] = Float(point.y)
                    //dict["num"] = Float(i)
                    
                    touchesArray.append(dict)
                    lineStartPoint = touchPoint
                    
                }
                
                buttonTemp.setNeedsDisplay()
            }
            
            self.setNeedsDisplay()
           
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        var touchPoint:CGPoint
        let touch:UITouch? = touches.first! as? UITouch
   
        
        if(touch != nil){
            
            
            touchPoint = touch!.locationInView(self)
            
            for(var i=0;i<buttonArray.count;i++){
                
                let buttonTemp = buttonArray[i]
             
                if(CGRectContainsPoint(buttonTemp.frame,touchPoint)){
                  
                    let tps = touchedArray.filter{el in el=="num\(i)"}
                    
                    if(tps.count > 0){
                        
                        lineEndPoint = touchPoint
                        self.setNeedsDisplay()
                        return
                    }
                    touchedArray.append("num\(i)")
                    buttonTemp.selected = true
                   
                    buttonTemp.setNeedsDisplay()
                    
                    let frameTemp = buttonTemp.frame
                    let point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2)
                    var dict:Dictionary<String,Float> = [:]
                    dict["x"] = Float(point.x)
                    dict["y"] = Float(point.y)
                    dict["num"] = Float(i)

                    touchesArray.append(dict)
                    
                    break;
                    
                }
            }
            
            lineEndPoint = touchPoint
            self.setNeedsDisplay()
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var resultString:String = ""
        var isfirstPassword:Bool = false
        //println("end....\(touchedArray)")
        for p in touchesArray {
            if(p["num"] == nil){
                continue
            }
            let num=Int(p["num"]!)
            resultString = resultString + "\(num)"
        }
        drawed = true
        if((style == 1) || (style == 3) || (style == 4) || (style == 5)){
            
            success = rerificationDelegate!.verification(resultString)
            
        }else{
            isfirstPassword = resetDelegate!.isfirstPassword(resultString)
            success = resetDelegate!.resetPassword(resultString)
        }
        
        for i in 0..<touchesArray.count {
            
            if(touchesArray[i]["num"] == nil){
                continue
            }

            let selection:Int = Int(touchesArray[i]["num"]!)
            let buttonTemp = buttonArray[selection]
            buttonTemp.success = success
            buttonTemp.setNeedsDisplay()
        }
        self.setNeedsDisplay()
        
        //验证密码正确后的处理
        //内部验证密码正确的时候－－－开手势密码
        if((style == 3) && success){
            NSNotificationCenter.defaultCenter().postNotificationName("gesturePasswordCheckDeal", object: nil, userInfo: ["flag":3])
        }
        //内部验证密码正确的时候－－－关手势密码
        if((style == 4) && success){
            NSNotificationCenter.defaultCenter().postNotificationName("gesturePasswordCheckDeal", object: nil, userInfo: ["flag":4])
        }
        //修改手势密码验证原密码正确的时候
        if((style == 5) && success){
            NSNotificationCenter.defaultCenter().postNotificationName("gesturePasswordModify", object: nil, userInfo: ["flag":5])
        }
        //重置密码正确的时候
        if((style == 2) && success){
            if(isfirstPassword == false){
                NSNotificationCenter.defaultCenter().postNotificationName("gesturePasswordCheckDeal", object: nil, userInfo: ["flag":2])
            }else{
                
            }
        }
        //外部验证密码正确的时候
        if((style == 1) && success){
            NSNotificationCenter.defaultCenter().postNotificationName("gesturePasswordCheckDeal", object: nil, userInfo: ["flag":1])
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
       
        if(touchesArray.count<=0){
            return;
        }
       // println("drawRect\(touchedArray)")
        
        for var i=0;i<touchesArray.count;i++ {
            
            let context:CGContextRef = UIGraphicsGetCurrentContext()!
      
            if(touchesArray[i]["num"] == nil){
                touchesArray.removeAtIndex(i)
                //i = i-1;
                continue
            }
            
            if (success) {
                CGContextSetRGBStrokeColor(context, 2/255, 174/255, 240/255, 0.7);//线条颜色
            }
            else {
                CGContextSetRGBStrokeColor(context, 208/255, 36/255, 36/255, 0.7);//红色
            }
            
            CGContextSetLineWidth(context,5)
            
            CGContextMoveToPoint(context,CGFloat(touchesArray[i]["x"]!),CGFloat(touchesArray[i]["y"]!))
            
            if(i<touchesArray.count-1){
                
                CGContextAddLineToPoint(context,CGFloat(touchesArray[i+1]["x"]!),CGFloat(touchesArray[i+1]["y"]!))
            }
            else{
                
                if(success && drawed != true){
                    CGContextAddLineToPoint(context, lineEndPoint!.x,lineEndPoint!.y);
                }
            }
            CGContextStrokePath(context)
            
        }
    }
    

    
    func enterArgin() {
        
        touchesArray.removeAll()
        touchedArray.removeAll()
        
        for(var i=0;i<buttonArray.count;i++){
            
            let buttonTemp = buttonArray[i]
            buttonTemp.success = true
            buttonTemp.selected = false
            buttonTemp.setNeedsDisplay()
        }
        self.setNeedsDisplay()
    }
    

}
