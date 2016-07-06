//
//  LauncherScrollView.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/24.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class LauncherScrollView: UIScrollView {

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
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
    
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        return true
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
