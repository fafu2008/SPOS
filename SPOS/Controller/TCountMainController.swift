//
//  TCountMainController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/7.
//  Copyright © 2016年 虞邵鹏. All rights reserved.
//

import UIKit

class TCountMainController: UIViewController {
    
    var controller_dic:[NSString:AnyObject]?
    
    @IBOutlet weak var middleShadow: UIImageView!
    
    @IBOutlet weak var rechargeButton: UIButton!
    
    @IBOutlet weak var changeCashButton: UIButton!
    
    
    //@IBOutlet weak var btnCashierDesk: UIButton!
    @IBOutlet weak var lookTransButton: UIButton!
    @IBOutlet var centerLine: UIView!
    @IBOutlet weak var dayCost: UILabel!
    @IBOutlet weak var dayIncome: UILabel!
    @IBOutlet weak var labCount: UILabel!
    @IBOutlet weak var labCrash: UILabel!
    
    @IBOutlet weak var labRecharge: UILabel!
    
    @IBOutlet weak var labAppearn: UILabel!
    
    @IBOutlet weak var labBuyApp: UILabel!
    
    @IBOutlet weak var labOtherIncome: UILabel!
    
    @IBOutlet weak var labTransOut: UILabel!
    
    @IBOutlet weak var labSaleFee: UILabel!
    
    @IBOutlet weak var labOtherFee: UILabel!
    
    
    @IBOutlet weak var labTransIn: UILabel!
    
    
    @IBAction func rechargeTaped(sender: AnyObject) {
        print("充值taped")
    }
    
    
    @IBAction func transButtonTaped(sender: UIButton) {
    }
    
    func rightButtonTaped()
    {
        print("right button taped")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CashSendValue")
        {
            let controller = segue.destinationViewController as! TcountChangeCash
            controller.amount = self.controller_dic!["act_cash_amount"] as! String
            controller.bankName = self.controller_dic!["bank_name"] as! String
            controller.bankNo = self.controller_dic!["account_no"] as! String
        }
        else if (segue.identifier == "TcountTransCash")
        {
            let controller = segue.destinationViewController as! TcountTransCash
            controller.amount = self.controller_dic!["act_amount"] as! String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"rightIcon"), style: .Plain,target: nil, action: #selector(self.rightButtonTaped))
        
        let rightBtn = UIButton(type: .Custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 5, height: 34)
        rightBtn.setImage(UIImage(named:"rightIcon"), forState:.Normal)
        rightBtn.contentHorizontalAlignment = .Right
        
        rightBtn.addTarget(self, action: #selector(self.rightButtonTaped), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        //middleShadow.frame.size.width = SCREENWIDTH
        
        let rect1:CGRect = self.middleShadow.frame;
        let rect2:CGRect = self.lookTransButton.frame;
        print(SCREENWIDTH,SCREENHEIGHT)
        print(rect1,rect2);
        print(self.view.frame)
        print(self.centerLine.frame)
        //self.centerLine.frame.size.height = rect2.origin.y - rect1.origin.y - rect1.size.height;
        //self.centerLine.backgroundColor = UIColor.redColor()
        print(self.centerLine.frame.size.height)
        
        
        let lineView = UIView.init(frame: CGRectMake(0, 0, SCREENWIDTH, 1))
        lineView.backgroundColor = UIColor.lightGrayColor()
        print(lineView.frame)
        self.lookTransButton.addSubview(lineView)
        
        self.rechargeButton.setBackgroundImage(UIImage.init(imageLiteral:"btnn960130"), forState:UIControlState.Normal)
        self.rechargeButton.setBackgroundImage(UIImage.init(imageLiteral:"btnh960130"), forState:UIControlState.Highlighted)
        
        let button_line = UIView.init(frame: CGRectMake(1, 20, 27, 1))
        button_line.backgroundColor = BASE_UICOLOR
        self.changeCashButton.addSubview(button_line)
        
        //
        
        queryTcountState()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.recNotification(_:)), name: "changeCashNotify", object: nil)
    }
    
    func recNotification(notification: NSNotification)
    {
        if (notification.name == "changeCashNotify")
        {
            self.view.makeToast("提现成功")
            queryTcountState()
        }
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
    
    //MARK: -CollectionViewDatasource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SYTCell
        
        switch indexPath.row {
        case 0:
            cell.ivLOGO.image = UIImage(named: "xfcx")
            cell.lblTitle.text = "消费撤销"
        case 1:
            cell.ivLOGO.image = UIImage(named: "jjb")
            cell.lblTitle.text = "交接班"
        case 2:
            cell.ivLOGO.image = UIImage(named: "dy")
            cell.lblTitle.text = "打印"
        case 3:
            cell.ivLOGO.image = UIImage(named: "pjs")
            cell.lblTitle.text = "批结算"
        case 4:
            cell.ivLOGO.image = UIImage(named: "ycdd")
            cell.lblTitle.text = "异常订单"
        case 5:
            cell.ivLOGO.image = UIImage(named: "dysz")
            cell.lblTitle.text = "打印设置"
        case 6:
            cell.ivLOGO.image = UIImage(named: "sjbb")
            cell.lblTitle.text = "数据报表"
        default:
            cell.ivLOGO.image = nil
            cell.lblTitle.text = ""
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((SCREENWIDTH - 3) / 4, (SCREENWIDTH * 480 / 1242 - 3) / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 0, 1, 0)
    }
    
    func queryTcountTotalIncome()
    {
        do{
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                
                var data:NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
                
                let cur_data = NSDate.init()
                print(cur_data.description)
                
                if let str:String = cur_data.description{
                    data.setValue((str as NSString).substringToIndex(10), forKey: "sdate")
                

                    data.setValue((str as NSString).substringToIndex(10), forKey: "edate")
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
                                                
                                                self.dayIncome.text = dic1["in"] as? String
                                                self.dayCost.text = dic1["out"] as? String
                                                self.labBuyApp.text = dic1["type6"] as? String
                                                self.labAppearn.text = dic1["type3"] as? String
                                                self.labRecharge.text = dic1["type1"] as? String
                                                self.labTransIn.text = dic1["type2"] as? String
                                                self.labSaleFee.text = dic1["type8"] as? String
                                                self.labOtherFee.text = dic1["type7"] as? String
                                                self.labOtherIncome.text = dic1["type9"] as? String
                                                self.labTransOut.text = dic1["type4"] as? String

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
    
    func queryTcountState() {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            if let signString = DefaultKit.signString(token, data: nil) {
                let rsa = RSAHelper()
                let sign = rsa.rsaEncrypt(signString.md5, keyPath: DefaultKit.filePath("public_key.pem"))
                let manager = AFNetworkingManager()
                manager.postRequest("/accountshop?token=\(token)", postData: ["sign" : sign], callback: { (dic, err) in
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

                                          self.labCount.text = dic1["act_balance"] as? String
                                          self.labCrash.text = dic1["act_cash_amount"] as? String
                                            
                                          self.controller_dic = dic1
                                            
                                            self.queryTcountTotalIncome()
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
}

