//
//  TcountTransDetail.swift
//  SPOS
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation
import UIKit

class TcountTransDetail: UIViewController{
    
    var typeStr:String?
    var infoDic:NSDictionary?
    var appInfoDic:NSDictionary?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (self.typeStr == "购买应用")
        {
            if let aod_id:String = self.infoDic!["aod_id"] as! String
            {
                query_buy_app_record(aod_id)
            }
            else
            {
                self.view.makeToast("数据异常，请返回上级菜单")
            }
        }
        else
        {
            build_the_common_view()
        }
    }
    
    func query_buy_app_record(aod_id:String)
    {
        let data : [String : AnyObject] = ["aod_id" : aod_id]
        //let data : [String : AnyObject] = ["page" : "1","pagesize" : "9"]
        let (token , param) = DefaultKit.packageParam(data)
        
        if (param == nil)
        {
            print("changeCash error")
            return
        }
        
        let manager = AFNetworkingManager()
        manager.postRequest("accountshop/applog?token=\(token!)", postData: param, callback: {[weak self] (dic, error) in
            //manager.postRequest("shopappstore?token=\(token!)", postData: param, callback: {[weak self] (dic, error) in
            
            if let value = dic as? [String : AnyObject] {
                
                print(value)
                
                if value["errcode"] as? Int == 0 {
                    if let sign = value["sign"] as? String {
                        let rsa = RSAHelper()
                        let result = rsa.rsaPDecrypt(sign, keyPath: DefaultKit.filePath("public_key.pem"))
                        let result2 = DefaultKit.validString(value).md5
                        if result2 == result {
                            
                            if let data = value["data"] as? String {
                                let aes = AESHelper()
                                let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as? String
                                let aesValue = aes.aes256_decrypt(aes_key!, hexString: data)
                                print(aesValue)
                                
                                let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                
                                do{
                                    
                                    
                                    if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? Dictionary<String , AnyObject>{
                                        
                                        print(dic1)
                                        
                                        let list:NSArray = dic1["list"] as! NSArray
                                        self!.appInfoDic = list[0] as? NSDictionary
                                        self!.build_app_detail_view()
                                    }
                                }
                                catch {
                                    
                                }
                                
                                
                            }
                        }else{
                            print("验签没通过")
                        }
                        
                    }
                }
                else
                {
                    self!.view.makeToast(value["msg"] as! String)
                }
            }
            })
    }
    
    func build_app_detail_view(){
        
        if ((self.infoDic) != nil)
        {
            print(self.infoDic)
        }
        
        self.navigationItem.title = self.typeStr! + "详情"
        self.view.backgroundColor = UIColor.whiteColor()
        let amount = self.infoDic!["acl_amount"] as! NSString
        var state = self.infoDic!["acl_status"] as! NSString
        let acl_id = self.infoDic!["acl_id"] as! NSString
        let acl_time = self.infoDic!["acl_time"] as! NSString
        let acl_type = self.infoDic!["acl_type"] as! NSString
        //应用信息
        let app_name = self.appInfoDic!["app_name"] as! NSString
        let app_num = self.appInfoDic!["buy_num"] as! NSString
        let shop_name = self.appInfoDic!["shop_full_name"] as! NSString
        
        var incomeOrCost = 0
        
        if (acl_type.intValue == 1 || acl_type.intValue == 2 || acl_type.intValue == 3)
        {
            incomeOrCost = 1
        }
        else
        {
            incomeOrCost = 2
        }
        
        switch (state.intValue)
        {
        case 1:
            state = "成功"
        case 2:
            state = "待处理"
        case 4:
            state = "失败"
        default:
            state = "error"
        }
        
        //交易类型
        let lab1:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+20, 70, 25), title: "交易类型:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab1)
        
        let text1:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+20, 100, 25), title: self.typeStr!, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text1)
        
        let line1 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+50, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line1)
        
        //交易金额
        let lab2:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+60, 70, 25), title: "交易金额:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab2)
        
        var amount_lab = amount as String
        
        if (incomeOrCost == 1)
        {
            amount_lab = "+"+(amount as String)
        }
        else if (incomeOrCost == 2)
        {
            amount_lab = (amount as String)
        }
        
        let text2:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+60, 100, 25), title: amount_lab, font: UIFont.systemFontOfSize(14), color: UIColor.redColor())
        self.view.addSubview(text2)
        
        let line2 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+90, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line2)
        
        //交易状态
        let lab3:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+100, 70, 25), title: "交易状态:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab3)
        
        let text3:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+100, 100, 25), title: state as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text3)
        
        let line3 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+130, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line3)
        
        //交易时间
        let lab4:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+140, 70, 25), title: "交易时间:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab4)
        
        let text4:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+140, 150, 25), title: acl_time as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text4)
        
        let line4 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+170, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line4)
        
        //订单编号
        let lab5:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+180, 70, 25), title: "订单编号:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab5)
        
        let text5:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+180, 100, 25), title: acl_id as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text5)
        
        let line5 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+210, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line5)
        
        //应用名称
        let lab6:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+220, 70, 25), title: "应用名称:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab6)
        
        let text6:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+220, SCREENWIDTH-135, 25), title: app_name as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text6)
        
        let line6 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+250, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line6)
        
        //购买份数
        let lab7:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+260, 70, 25), title: "购买份数:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab7)
        
        let text7:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+260, SCREENWIDTH-135, 25), title: app_num as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text7)
        
        let line7 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+290, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line7)
        
        //购买份数
        let lab8:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+300, 70, 25), title: "购买门店:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab8)
        
        let text8:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+300, SCREENWIDTH-135, 25), title: shop_name as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text8)
        
        let line8 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+330, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line8)
    }
    
    func build_the_common_view(){
        
        if ((self.infoDic) != nil)
        {
            print(self.infoDic)
        }
        
        self.navigationItem.title = self.typeStr! + "详情"
        self.view.backgroundColor = UIColor.whiteColor()
        let amount = self.infoDic!["acl_amount"] as! NSString
        var state = self.infoDic!["acl_status"] as! NSString
        let acl_id = self.infoDic!["acl_id"] as! NSString
        let acl_time = self.infoDic!["acl_time"] as! NSString
        let acl_type = self.infoDic!["acl_type"] as! NSString
        let extra_info = self.infoDic!["acl_remark"] as! NSString
        var incomeOrCost = 0
        
        if (acl_type.intValue == 1 || acl_type.intValue == 2 || acl_type.intValue == 3)
        {
            incomeOrCost = 1
        }
        else
        {
            incomeOrCost = 2
        }
        
        switch (state.intValue)
        {
        case 1:
            state = "成功"
        case 2:
            state = "待处理"
        case 4:
            state = "失败"
        default:
            state = "error"
        }
        
        //交易类型
        let lab1:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+20, 70, 25), title: "交易类型:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab1)
        
        let text1:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+20, 100, 25), title: self.typeStr!, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text1)
        
        let line1 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+50, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line1)
        
        //交易金额
        let lab2:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+60, 70, 25), title: "交易金额:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab2)
        
        var amount_lab = amount as String
        
        if (incomeOrCost == 1)
        {
            amount_lab = "+"+(amount as String)
        }
        else if (incomeOrCost == 2)
        {
            amount_lab = (amount as String)
        }
        
        let text2:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+60, 100, 25), title: amount_lab, font: UIFont.systemFontOfSize(14), color: UIColor.redColor())
        self.view.addSubview(text2)
        
        let line2 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+90, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line2)
        
        //交易状态
        let lab3:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+100, 70, 25), title: "交易状态:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab3)
        
        let text3:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+100, 100, 25), title: state as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text3)
        
        let line3 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+130, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line3)
        
        //交易时间
        let lab4:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+140, 70, 25), title: "交易时间:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab4)
        
        let text4:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+140, 150, 25), title: acl_time as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text4)
        
        let line4 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+170, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line4)
        
        //订单编号
        let lab5:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+180, 70, 25), title: "订单编号:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab5)
        
        let text5:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+180, 100, 25), title: acl_id as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text5)
        
        let line5 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+210, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line5)
        
        //备注
        let lab6:UILabel = DefaultKit.makeLable(CGRectMake(20, NAVITEMHEIGHT+220, 70, 25), title: "备注:", font: UIFont.boldSystemFontOfSize(14), color: UIColor.blackColor())
        self.view.addSubview(lab6)
        
        let text6:UILabel = DefaultKit.makeLable(CGRectMake(95, NAVITEMHEIGHT+220, SCREENWIDTH-135, 25), title: extra_info as String, font: UIFont.systemFontOfSize(14), color: UIColor.grayColor())
        self.view.addSubview(text6)
        
        let line6 = DefaultKit.makeLine(CGRectMake(95, NAVITEMHEIGHT+250, SCREENWIDTH-135, 1), color: UIColor.lightGrayColor())
        self.view.addSubview(line6)
    }
    
    func setInfo(type:String, info:NSDictionary)
    {
        self.typeStr = type
        self.infoDic = info
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}