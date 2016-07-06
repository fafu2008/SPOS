//
//  AppItem.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/17.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation

class AppItem : NSObject{
    
    var app_fee:String = ""
    
    var app_id:String = ""
    var app_intro:String = ""
    var app_logo:String = ""
    var app_name:String = ""
    var app_pay_type:String = ""
    var app_price:String = ""
    var app_size:String = ""
    var app_tryout:String = ""
    var app_type:String = ""
    var app_ver:String = ""
    var app_ver_id:String = ""
    var apt_id:String = ""
    var apt_name:String = ""
    var dev_id:String = ""
    var dev_name:String = ""
    var sap_ver_id:String = ""
    var ver_intro:String = ""
    var ver_photos:NSArray = [""]
    var ver_upd_time:String = ""
    
    var sap_expired_date = ""
    var sap_expired_days = ""
    
    func getFeeType() -> String{
        
        var feeString:String
        
        switch app_pay_type {
        case "0":
            feeString = "免费"
        case "1":
            feeString = "元/天"
        case "2":
            feeString = "元/周"
        case "3":
            feeString = "元/月"
        case "4":
            feeString = "元/季度"
        case "5":
            feeString = "元/年"
        case "6":
            feeString = "元/次"
        default:
            feeString = "免费"
        }
        return feeString
    }
    
    func getFeeType2() -> String{
        
        var feeString:String
        
        switch app_pay_type {
        case "0":
            feeString = "免费"
        case "1":
            feeString = "天"
        case "2":
            feeString = "周"
        case "3":
            feeString = "月"
        case "4":
            feeString = "季度"
        case "5":
            feeString = "年"
        case "6":
            feeString = "次"
        default:
            feeString = "免费"
        }
        return feeString
    }

    

}