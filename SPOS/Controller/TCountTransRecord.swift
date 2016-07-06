//
//  TCountTransRecord.swift
//  SPOS
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import Foundation

import UIKit

let TOTAL_TYPE = 1
let OTHER_TYPE = 2

class TCountTransRecord: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var refreshControl = UIRefreshControl()
    private var recordList : NSMutableArray?
    
    @IBOutlet weak var scrollVIew: UITableView!
    @IBOutlet weak var topTextView: UIView!
    
    var beginDate:String?
    var endDate:String?
    var transState:String?
    var state:Int?
    var type:Int?
    var transType:String?
    var page_info:[String : AnyObject]?
    
    var report_data:NSMutableDictionary?
    var total_lab:UILabel?
    var total_in_lab:UILabel?
    var total_out_lab:UILabel?
    var view_type:Int?
    
    var other_total_lab:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
        buildTopTextFiled(TOTAL_TYPE)
        view_type = TOTAL_TYPE
        
        //self.scrollVIew.backgroundColor = BASE_TEXT_GRAYCOLOR
        self.scrollVIew.delegate = self
        self.scrollVIew.dataSource = self
        
        self.recordList = NSMutableArray.init(capacity: 0)
        self.report_data = NSMutableDictionary.init(capacity: 0)
        
        //self.queryTcountTransDetail(1)
        
        //NSNotificationCenter.defaultCenter().postNotificationName("tcountTransRdsFilter", object: nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.recNotification(_:)), name: "tcountTransRdsFilter", object: nil)
        
        //添加刷新
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "刷新中")
        self.scrollVIew.addSubview(refreshControl)
        
        self.queryTcountTotalIncome()
    }
    
    func buildTopTextFiled(type:Int)
    {
        for view in self.topTextView.subviews
        {
            view.removeFromSuperview()
        }
        
        if (type == TOTAL_TYPE)
        {
        self.total_lab = DefaultKit.makeLable(CGRectMake(20, 15, (SCREENWIDTH-62)/3, 20), title: "", font: UIFont.systemFontOfSize(14), color: BASE_UICOLOR)
        self.topTextView.addSubview(self.total_lab!)
        
        let lab1 = DefaultKit.makeLable(CGRectMake(20, 35, (SCREENWIDTH-62)/3, 20), title: "余额", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
        self.topTextView.addSubview(lab1)
        
        let lineView1 = UIView.init(frame: CGRectMake(SCREENWIDTH/3, 10, 1, 50))
        lineView1.backgroundColor = UIColor.lightGrayColor()
        self.topTextView.addSubview(lineView1)
        
        self.total_in_lab = DefaultKit.makeLable(CGRectMake(41+(SCREENWIDTH-62)/3, 15, (SCREENWIDTH-62)/3, 20), title: "", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
        self.topTextView.addSubview(self.total_in_lab!)
        
        let lab2 = DefaultKit.makeLable(CGRectMake(41+(SCREENWIDTH-62)/3, 35, (SCREENWIDTH-62)/3, 20), title: "收入", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
        self.topTextView.addSubview(lab2)
        
        let lineView2 = UIView.init(frame: CGRectMake(41+(SCREENWIDTH-62)*2/3, 10, 1, 50))
        lineView2.backgroundColor = UIColor.lightGrayColor()
        //print(lineView.frame)
        self.topTextView.addSubview(lineView2)
        
        self.total_out_lab = DefaultKit.makeLable(CGRectMake(62+(SCREENWIDTH-62)*2/3, 15, (SCREENWIDTH-62)/3, 20), title: "", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
        self.topTextView.addSubview(self.total_out_lab!)
        
        let lab3 = DefaultKit.makeLable(CGRectMake(62+(SCREENWIDTH-62)*2/3, 35, (SCREENWIDTH-62)/3, 20), title: "支出", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
        self.topTextView.addSubview(lab3)
        }
        else if (type == OTHER_TYPE)
        {
            self.other_total_lab = DefaultKit.makeLable(CGRectMake(20,15,120,30), title: "+10000", font: UIFont.systemFontOfSize(20), color: BASE_UICOLOR)
            self.topTextView.addSubview(self.other_total_lab!)
            
            let lab = DefaultKit.makeLable(CGRectMake(20,45,120,15), title: "总额", font: UIFont.systemFontOfSize(14), color: UIColor.blackColor())
            self.topTextView.addSubview(lab)
        }
    }
    
    func recNotification(notification: NSNotification)
    {
        if (notification.name == "tcountTransRdsFilter")
        {
            if let userInfo = notification.userInfo as? [String : AnyObject] {
                self.beginDate = userInfo["beginTime"] as! String
                print(self.beginDate)
                
                self.endDate = userInfo["endTime"] as! String
                self.state = userInfo["state"] as! Int
                self.type = userInfo["type"] as! Int
                
                print(self.state,self.type)
                view_type = TOTAL_TYPE
                //buildTopTextFiled(TOTAL_TYPE)
                reloadTransRecodsList()
                
                /*接口不支持单项总额查询
                if (self.type == 0)
                {
                    view_type = TOTAL_TYPE
                    buildTopTextFiled(TOTAL_TYPE)
                    self.queryTcountTotalIncome()
                }
                else
                {
                    view_type = OTHER_TYPE
                    buildTopTextFiled(OTHER_TYPE)
                    self.queryTcountTotalIncome()
                }
             */
                //self.queryTcountTotalIncome()
            }
        }
    }
    
    func reloadTransRecodsList()
    {
        self.recordList?.removeAllObjects()
        
        self.queryTcountTransDetail(1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = self.parentViewController as? MenuViewController {
            controller.addPanGestureRecognizer()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let controller = self.parentViewController as? MenuViewController {
            controller.removePanGestureRecognizer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func queryTcountTotalIncome()
    {
        do{
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            
            var data:NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
            
            if (self.beginDate != nil){
                data.setValue(self.beginDate, forKey: "sdate")
            }
            
            if (self.endDate != nil)
            {
                data.setValue(self.endDate, forKey: "edate")
            }
            
            if (self.state != nil)
            {
                data.setValue("\(self.state!)", forKey: "status")
            }
            
            if (self.type != nil)
            {
                data.setValue("\(self.type!)", forKey: "type")
            }
            
            var post_data:NSMutableDictionary?
            if (data.count > 0)
            {
                let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            
                let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as?String
                let aes = AESHelper()
            
            
                let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
                let aes_string = aes.aes_encrypt(jsonStr, key: aes_key)
                let signString = DefaultKit.signString(token, data: aes_string)
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                post_data = ["sign" : sign,"data" : aes_string]
            }
            else
            {
            
                let signString = DefaultKit.signString(token, data: nil)
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                post_data = ["sign" : sign]
            }
                let manager = AFNetworkingManager()
                manager.postRequest("/accountshop/report?token=\(token)", postData: post_data, callback: { (dic, err) in
                    if let value = dic as? [String : AnyObject] {
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
                                                
                                                
                                                if (self.view_type == TOTAL_TYPE)
                                                {
                                                    let in_str = dic1["in"] as! NSString
                                                
                                                    let out_str = dic1["out"] as! NSString
                                                    let total = in_str.intValue + out_str.intValue
                                                
                                                    let str = total as Int32
                                                
                                                    self.total_lab!.text = "\(str)"
                                                    self.total_in_lab!.text = dic1["in"] as! String
                                                    self.total_out_lab!.text = dic1["out"] as! String
                                                }
                                                else
                                                {
                                                    //接口没有，做不了单项总额查询
                                                    //self.other_total_lab?.text = ""
                                                }
                                                    
                                                self.queryTcountTransDetail(1)
                                                /*
                                                self.labCount.text = dic1["act_balance"] as? String
                                                self.labCrash.text = dic1["act_cash_amount"] as? String
                                                self.dayIncome.text = dic1["today_in"] as? String
                                                self.dayCost.text = dic1["today_out"] as? String
                                                
                                                self.controller_dic = dic1
 */
                                            }
                                        }
                                        catch {
                                            
                                        }
                                        
                                        
                                    }
                                }else{
                                    print("验签没通过")
                                }
                                
                            }
                        }else if value["errcode"] as? Int > 0 {
                            
                            print(value["msg"])
                            
                        }else{
                            
                        }
                    }
                })
            
        }
        }
        catch
        {
            print("TCountTransRecord解析异常")
        }
        
    }
    
    func queryTcountTransDetail(pagenum:Int) {
        do{
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            
            var data:NSMutableDictionary = ["page" : "\(pagenum)"]
            
            if (self.beginDate != nil){
                data.setValue(self.beginDate, forKey: "sdate")
            }
            
            if (self.endDate != nil)
            {
                data.setValue(self.endDate, forKey: "edate")
            }
            
            if (self.state != nil)
            {
                data.setValue("\(self.state!)", forKey: "status")
            }
            
            if (self.type != nil)
            {
                data.setValue("\(self.type!)", forKey: "type")
            }
            
            let json = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            
            let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as?String
            let aes = AESHelper()
            
            
            let jsonStr = String(data: json, encoding: NSUTF8StringEncoding)
            let aes_string = aes.aes_encrypt(jsonStr, key: aes_key)
            let signString = DefaultKit.signString(token, data: aes_string)
            
            let rsa = RSAHelper()
            if let sign = rsa.rsaEncrypt(signString!.md5, keyPath: DefaultKit.filePath("public_key.pem"))
            
            {
                let manager = AFNetworkingManager()
                manager.postRequest("/accountshop/tlog?token=\(token)", postData: ["sign" : sign,"data" : aes_string], callback: { (dic, err) in
                    
                    if (self.refreshControl.refreshing == true)
                    {
                        self.refreshControl.endRefreshing()
                    }
                    
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
                                                
                                                if let pages = dic1["pages"] as? [String : AnyObject]{
                                                    
                                                    self.page_info = pages
                                                    
                                                    let page = pages["page"] as? Int
                                                    let totalpage = pages["totalpage"] as?Int
                                                    
                                                    if let list = dic1["list"] as? NSArray{
                                                        print(list.count)
                                                        
                                                        self.recordList!.addObjectsFromArray(list as [AnyObject])
                                                        
                                                        self.scrollVIew.reloadData()
                                                    }
                                                    
                                                    if (totalpage == 0)
                                                    {
                                                        self.view.makeToast("记录为空")
                                                        return
                                                    }
                                                    
                                                    if (page == totalpage)
                                                    {
                                                       
                                                        print("最后一页")
 
                                                    }
                                                    else
                                                    {
                                                        return
                                                    }
                                                    
                                                    
                                                }
                                                
                                                /*
                                                self.labCount.text = dic1["act_balance"] as? String
                                                self.labCrash.text = dic1["act_cash_amount"] as? String
                                                self.dayIncome.text = dic1["today_in"] as? String
                                                self.dayCost.text = dic1["today_out"] as? String
                                                */
                                            }
                                        }
                                        catch {
                                            
                                        }
                                        
                                        
                                    }
                                }else{
                                    print("验签没通过")
                                }
                                
                            }
                        }else if value["errcode"] as? Int > 0 {
                            
                            print(value["msg"])
                            
                        }else{
                            
                        }
                    }
                })
            }
        }
        
    }
    catch
    {
        print("TCountTransRecord解析异常")
    }
}
    
    // 刷新数据
    func refreshData() {
        print("refresh")
        
        if (self.page_info != nil)
        {
            let page = self.page_info!["page"] as? Int
            let totalpage = self.page_info!["totalpage"] as?Int
            
            if (totalpage > 0 && page > 0 && (page < totalpage))
            {
                queryTcountTransDetail(page!+1)
            }
            else if (page == totalpage)
            {
                self.view.makeToast("已经是最后一页")
                self.refreshControl.endRefreshing()
            }
            else
            {
                self.view.makeToast("数据异常")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList!.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let dic:NSDictionary = (self.recordList?.objectAtIndex(index))! as! NSDictionary
        
        let type:NSString = (dic["acl_type"] as? NSString)!
        var title:String?
        switch (type.intValue)
        {
        case 1:
            title = "充值"
        case 2:
            title = "转入"
        case 3:
            title = "应用收入"
        case 4:
            title = "转出"
        case 5:
            title = "提现"
        case 6:
            title = "购买应用"
        case 7:
            title = "其他支出"
        case 8:
            title = "营销支出"
        case 9:
            title = "其它收入"
        default:
            title = "error"
        }
        
        let controller = TcountTransDetail()
        controller.setInfo(title!, info: dic)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "newsCell")
        
        cell.backgroundColor = UIColor.whiteColor()
        let obj = self.recordList![indexPath.row]
        
        let arr:UIImageView = UIImageView.init(frame: CGRectMake(SCREENWIDTH-25, 30, 5, 9.25))
        arr.image = UIImage.init(imageLiteral: "arrow")
        cell.contentView.addSubview(arr)
        
        //let obj = (self.recordList?.objectAtIndex(i))! as! [String : AnyObject]
        
        let type:NSString = (obj["acl_type"] as? NSString)!
        let status:NSString = (obj["acl_status"] as? NSString)!
        let date:NSString = (obj["acl_time"] as? NSString)!
        let amount:NSString = (obj["acl_amount"] as? NSString)!
        
        let type_lab:UILabel = UILabel.init(frame: CGRectMake(25, 5, 65, 30))
        var type_total:Int = 0//1表示收入，2表示支出
        
        switch (type.intValue)
        {
        case 1:
            type_lab.text = "充值"
            type_total = 1
        case 2:
            type_lab.text = "转入"
            type_total = 1
        case 3:
            type_lab.text = "应用收入"
            type_total = 1
        case 4:
            type_lab.text = "转出"
            type_total = 2
        case 5:
            type_lab.text = "提现"
            type_total = 2
        case 6:
            type_lab.text = "购买应用"
            type_total = 2
        case 7:
            type_lab.text = "其他支出"
            type_total = 2
        case 8:
            type_lab.text = "营销支出"
            type_total = 2
        case 9:
            type_lab.text = "其他收入"
            type_total = 2
        default:
            type_lab.text = "error"
        }
        
        type_lab.textColor = UIColor.blackColor()
        type_lab.font = UIFont.systemFontOfSize(16)
        type_lab.textAlignment = .Left
        cell.contentView.addSubview(type_lab)
        
        let status_lab:UILabel = UILabel.init(frame: CGRectMake(25, 32, 80, 15))
        
        switch (status.intValue)
        {
        case 1:
            status_lab.text = "交易成功"
        case 2:
            status_lab.text = "交易待处理"
        case 4:
            status_lab.text = "失败"
        default:
            status_lab.text = "error"
        }
        
        status_lab.textColor = UIColor.lightGrayColor()
        status_lab.font = UIFont.systemFontOfSize(12)
        status_lab.textAlignment = .Left
        cell.contentView.addSubview(status_lab)
        
        let date_lab:UILabel = UILabel.init(frame: CGRectMake(25, 47, 150, 15))
        
        date_lab.text = date as String
        
        date_lab.textColor = UIColor.lightGrayColor()
        date_lab.font = UIFont.systemFontOfSize(12)
        date_lab.textAlignment = .Left
        cell.contentView.addSubview(date_lab)
        
        let amount_lab:UILabel = UILabel.init(frame: CGRectMake(25+SCREENWIDTH/2, 5, 125, 30))
        
        amount_lab.text = amount as String
        amount_lab.textColor = BASE_UICOLOR
        
        if (type_total == 1)
        {
            amount_lab.text = "+"+amount_lab.text!
            //amount_lab.textColor = BASE_UICOLOR
        }
        /*
         else if (type_total == 2)
         {
         amount_lab.text = "-"+amount_lab.text!
         amount_lab.textColor = BASE_UICOLOR
         }*/
        
        amount_lab.font = UIFont.systemFontOfSize(16)
        amount_lab.textAlignment = .Left
        cell.contentView.addSubview(amount_lab)

        return cell;
    }
}