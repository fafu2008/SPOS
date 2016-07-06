//
//  MyAppsViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/18.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class MyAppsViewController: UIViewController ,SimpleAppCellProtocol{

    
    var currentPage = 1
    var totalPage = 1
    
    var appArray : NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏状态栏方法
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.appArray = NSMutableArray.init(capacity: 0)

        
        let leftgesture = UISwipeGestureRecognizer(target: self, action: #selector(MyAppsViewController.viewSwipe(_:)))
        leftgesture.direction = .Left
        self.view.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: #selector(MyAppsViewController.viewSwipe(_:)))
        rightgesture.direction = .Right
        self.view.addGestureRecognizer(rightgesture)
        
        getMyAppsItemList(1)

    }
    
    func viewSwipe(sender:UISwipeGestureRecognizer){
        if(sender.direction == .Right){
            if(currentPage > 1){
                getMyAppsItemList(currentPage - 1)
            }else {
                self.view.makeToast("没有上一页了")
            }
        }
        if(sender.direction == .Left){
            if(currentPage < totalPage){
                getMyAppsItemList(currentPage + 1)
            }else {
                self.view.makeToast("没有下一页了")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        TTGLog("viewWillAppear")
    }
    
    
    func createAppItemViews(){
        for subview in self.view.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        if let count = appArray?.count{
            
            for i in 0..<count{
                
                let row:Int = i/3
                let column:Int = i%3
                
                let tempApp:AppItem = appArray![i] as! AppItem
                
                let _x = (80 * CGFloat(column) + ((self.view.bounds.width / 4 - 60) * (CGFloat(column) + 1)))
                let _y = ((self.view.bounds.height / 4) - 110) * (CGFloat(row) + 1) + (110 * CGFloat(row)) + 64
                let app = SimpleAppCell(frame: CGRectMake(_x, _y, 80, 110) ,appItem: tempApp)
                
                app.delegate = self
                self.view.addSubview(app)
                
            }
        }
        
        
        if(appArray?.count == 0){
            
            let empty:UILabel = UILabel(frame: CGRect(x: 50, y: 250, width: self.view.bounds.width - 100 , height: 50))
            empty.contentMode = UIViewContentMode.Center
            empty.textAlignment = NSTextAlignment.Center
            empty.textColor = UIColor.grayColor()
            empty.font = UIFont.systemFontOfSize(20)
            empty.text = "还没有应用"
            self.view.addSubview(empty)
            
        }else{
            
            let pageView = AppStorePageView(frame: CGRectMake((self.view.bounds.width - 200)/2, self.view.bounds.height - 50 , 200, 25), currentPage: self.currentPage, totalPage: self.totalPage)
            
            pageView.left.addTarget(self, action: #selector(MyAppsViewController.previousClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
            pageView.right.addTarget(self, action: #selector(MyAppsViewController.nextClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(pageView)
            
        }
        
    }
    
    func previousClicked(){
        if(currentPage > 1){
            getMyAppsItemList(currentPage - 1)
        }else {
            self.view.makeToast("没有上一页了")
        }
    }
    func nextClicked(){
        if(currentPage < totalPage){
            getMyAppsItemList(currentPage + 1)
        }else {
            self.view.makeToast("没有下一页了")
        }
    }
    
    func getMyAppsItemList(currentPage:Int){
        let data = ["size" : "3","type":"1,4","page":"\(currentPage)","pagesize":"9"]
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(self, urlString: "/shopapp", postData: data) { (data, error) in
            //print(data)
            if let pages = data!["pages"] as? [String : AnyObject]{
                if let totalnum = pages["totalpage"] as? Int {
                    self.totalPage = totalnum
                }
                if let curr = pages["page"] as? Int {
                    self.currentPage = curr
                }
            }
            if let applist = data!["list"] as? NSArray{
                self.appArray?.removeAllObjects()
                for i in 0..<applist.count{
                    
                    let appItem:AppItem = AppItem()
                    
                    if let tempApp = applist[i] as? [String : AnyObject]{
                        if let name = tempApp["app_name"] as? String{
                            appItem.app_name = name
                        }
                        if let id = tempApp["app_id"] as? String{
                            appItem.app_id = id
                        }
                        if let image = tempApp["app_logo"] as? String{
                            appItem.app_logo = image
                        }
                        if let introduce = tempApp["app_intro"] as? String{
                            appItem.app_intro = introduce
                        }
                    }
                    
                    self.appArray?.addObject(appItem)
                    
                    
                }
                self.createAppItemViews()
            }
        }
        
    }
    
    func simpleAppDidClicked(appid : String){
        MyAppsViewController.entryApp(self,app_id: appid)
    }
    
    
    static func entryApp(controller:UIViewController, app_id:String){
        
        let data = ["app_id":"\(app_id)"]
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(controller, urlString: "shopapp/entry", postData: data) { (data, error) in
            
            var token = ""
            var aes_key = ""
            var token_url = ""
            var tml_url = ""
            var app_name = ""
            
            let mct_no:String! = NSUserDefaults.standardUserDefaults().objectForKey("mct_no") as? String
            let shop_no:String! = NSUserDefaults.standardUserDefaults().stringForKey("shop_no")
            
            let timestamp = NSDate().timeIntervalSince1970
            let language = "zh-cn"
            
            if let _token = data!["token"] as? String{
                token = _token
            }
            if let _aes_key = data!["aes_key"] as? String{
                aes_key = _aes_key
            }
            if let _token_url = data!["token_url"] as? String{
                token_url = _token_url
            }
            if let _tml_url = data!["tml_url"] as? String{
                tml_url = _tml_url
            }
            if let _app_name = data!["app_name"] as? String{
                app_name = _app_name
            }
            
            do{
                
                let data = ["mct_no" : "\(mct_no)","shop_no":"\(shop_no)", "timestamp":"\(timestamp)", "language":"\(language)"]
                
                print("data=\(data)")
                
                let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
                
                let aes = AESHelper()
                
                let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
                let aes_string = aes.aes_encrypt(jsonStr, key: aes_key)
                
                let manager = AFNetworkingManager()
                //?trade_type=app_token&token=\(token)"
                manager.postRequest2("\(token_url)", postData: ["data" : aes_string,"trade_type":"app_token","token":"\(token)"], callback: { (dic, err) in
                    if let value = dic as? [String : AnyObject] {
                        
                        controller.view.dismissHUD()
                        
                        TTGLog(value)
                        
                        if value["errcode"] as? String == "0" {
                         
                            if let data = value["data"] as? String {
                                
                                let aes = AESHelper()
                                let aesValue = aes.aes256_decrypt(aes_key, hexString: data)
                                let data1 = aesValue.dataUsingEncoding(NSUTF8StringEncoding)
                                do{
                                    if let dic1 = try NSJSONSerialization.JSONObjectWithData(data1!, options: .AllowFragments) as? Dictionary<String , AnyObject>{
                                        
                                        TTGLog(dic1)
                                        if let app_token = dic1["app_token"] as? String{
                                            let app_access_url = "\(tml_url)?app_token=\(app_token)&data=\(aes_string)"
                                            TTGLog(app_access_url)
                                            if(AppsWebViewController.onShow == false){
                                                let appWebController = AppsWebViewController()
                                                appWebController.request_url = app_access_url
                                                appWebController.app_name = app_name
                                                controller.navigationController?.pushViewController(appWebController, animated: true)
                                            }
                                        }
                                    }
                                }
                                catch {
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }else if value["errcode"] as? Int > 0 {
                            
                            controller.view.makeToast(value["msg"] as? String)
                            
                        }else{
                            
                        }
                    }
                })
                
                
            }
            catch
            {
                
            }
            
            
            
            
        }
        
    }
    
    
}
