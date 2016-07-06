//
//  SimpleAppCell.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/16.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

protocol SimpleAppCellProtocol:class {
    func simpleAppDidClicked(appid : String)
}

class SimpleAppCell: UIControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
     var app_image: UIImageView?
     var name_laber: UILabel?
     var type_laber: UILabel?
     var fee_laber: UILabel?
     var app_id:String = "123"
    var delegate:SimpleAppCellProtocol?
    
    init(frame: CGRect , appItem:AppItem) {
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.darkGrayColor()
        
        app_image = UIImageView()
        app_image?.userInteractionEnabled = false
        app_image?.contentMode = UIViewContentMode.ScaleToFill
        if let imagedata = NSData(contentsOfURL: NSURL(string: appItem.app_logo)!){
            app_image?.image = UIImage(data: imagedata)
        }
        addSubview(app_image!)
        
        name_laber = UILabel()
        name_laber?.contentMode = UIViewContentMode.Center
        name_laber?.textAlignment = NSTextAlignment.Center
        name_laber?.font = UIFont.systemFontOfSize(12)
        name_laber?.textColor = UIColor.blackColor()
        name_laber?.text = appItem.app_name
        addSubview(name_laber!)
        
        type_laber = UILabel()
        type_laber?.contentMode = UIViewContentMode.Center
        type_laber?.textAlignment = NSTextAlignment.Center
        type_laber?.font = UIFont.systemFontOfSize(10)
        type_laber?.textColor = UIColor.grayColor()
        type_laber?.text = appItem.apt_name
        //addSubview(type_laber!)
        
        fee_laber = UILabel()
        fee_laber?.contentMode = UIViewContentMode.Center
        fee_laber?.textAlignment = NSTextAlignment.Center
        fee_laber?.font = UIFont.systemFontOfSize(10)
        fee_laber?.textColor = UIColor.grayColor()
        fee_laber?.text = appItem.app_fee
        fee_laber?.numberOfLines = 2
        addSubview(fee_laber!)
        
        app_id = appItem.app_id
        
        self.addTarget(self, action: #selector(SimpleAppCell.AppItemClick), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = super.frame.width
        let h = super.frame.height
        app_image?.frame = CGRectMake(15, 5, w - 30, w - 30)
        
        name_laber?.frame = CGRectMake(5, h/2 + 5, w - 10, 20)
        //type_laber?.frame = CGRectMake(5, h/2 + 20, w - 10, 15)
        fee_laber?.frame = CGRectMake(5, h/2 + 20 + 15 - 5, w - 10, 15)
        
    }
    
    
    func AppItemClick(){
        TTGLog("AppItemClick")
        //NSNotificationCenter.defaultCenter().postNotificationName("AppItemClickEvent", object: nil, userInfo: ["app_id":app_id])
        self.delegate?.simpleAppDidClicked(app_id)
    }
    
}
