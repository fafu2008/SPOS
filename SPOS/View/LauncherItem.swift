//
//  LauncherItem.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/24.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

protocol LaucherItemDelegate {
    func didDeleteItem(item : LauncherItem)
}

class LauncherItem: UIControl {

    var dragging : Bool{
        set{
            if newValue == dragging {
                return
            }
            self.dragging = newValue
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: { 
                if self.dragging {
                    self.transform = CGAffineTransformMakeScale(1.2, 1.2)
                    self.alpha = 0.7
                }else{
                    self.transform = CGAffineTransformIdentity
                    self.alpha = 1
                }
                }) { (value) in
                    
            }
        }
        get{
            return self.dragging
        }
    }
    var deletable : Bool = false
    var delegate : LaucherItemDelegate?
    var title : String
    var image : String
    var closeButton :UIButton
    var badge : CustomBadge?
    
    init(frame :CGRect, title : String , image : String ,deletable : Bool) {
        
        
        self.deletable = deletable
        self.title = title
        self.image = image
        closeButton = UIButton()
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = ""
        self.image = ""
        closeButton = UIButton()
        super.init(coder: aDecoder)
    }

    func layoutItem() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        self.backgroundColor = UIColor.clearColor()
        
        let itemImageView = UIImageView(image: UIImage(named: title == "" ? "addn" : image))
        itemImageView.frame = CGRectMake(self.bounds.size.width / 2 - 22, self.bounds.size.height / 2 - 22, 44, 44)
        itemImageView.contentMode = .ScaleAspectFit
        self.addSubview(itemImageView)
        
        let itemLabel = UILabel(frame: CGRectMake(0 , self.bounds.size.height / 2 + 32 , self.bounds.size.width , 19))
        itemLabel.backgroundColor = UIColor.clearColor()
        itemLabel.textColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
        itemLabel.font = UIFont.systemFontOfSize(13)
        itemLabel.textAlignment = .Center
        itemLabel.adjustsFontSizeToFitWidth = true
        itemLabel.text = title
        self.addSubview(itemLabel)
        
        if let badgeT = badge {
            badgeT.frame = CGRectMake(self.frame.size.width - badgeT.bounds.size.width - 7, 7, badgeT.bounds.size.width, badgeT.bounds.size.height)
            self.addSubview(badgeT)
        }
        if deletable {
            closeButton.frame = CGRectMake(self.frame.size.width-35, 5, 30, 30)
            closeButton.setBackgroundImage(UIImage(named: "deleten"), forState: .Normal)
            closeButton.setBackgroundImage(UIImage(named: "deleteh"), forState: .Highlighted)
            closeButton.addTarget(self, action: #selector(LauncherItem.closeItem(_:)), forControlEvents: .TouchUpInside)
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //删除按钮触发事件
    func closeItem(sender : AnyObject) {
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: { 
            self.alpha = 0
            self.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
            }) { (value) in
                
        }
        self.delegate?.didDeleteItem(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        self.nextResponder()?.touchesMoved(touches, withEvent: event)
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.nextResponder()?.touchesEnded(touches, withEvent: event)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        self.nextResponder()?.touchesCancelled(touches, withEvent: event)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setBadgeText(text : String) {
        if text.isEmpty {
            badge = nil
        }else{
            badge = CustomBadge(frame: CGRectZero, badgeText: text)
        }
        layoutItem()
        
    }
    
    func  setCustomBadge(customBadge : CustomBadge) {
        badge = customBadge
        layoutItem()
    }

}
