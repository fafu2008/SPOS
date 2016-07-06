//
//  TcountRecharge.swift
//  SPOS
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class TcountRecharge: UIViewController , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,APNumberPadDelegate{
    
    @IBAction func cleanButtonTaped(sender: AnyObject) {
        cashNumber.text = "请输入金额";
        cashNumber.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3);
    }
    @IBOutlet weak var cashNumber: UILabel!
    
    func rightButtonTaped()
    {
        print("right button taped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"rightIcon"), style: .Plain,target: nil, action: #selector(self.rightButtonTaped))
        
        let rightBtn = UIButton(type: .Custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 5, height: 34)
        rightBtn.setImage(UIImage(named:"rightIcon"), forState:.Normal)
        rightBtn.contentHorizontalAlignment = .Right
        
        rightBtn.addTarget(self, action: #selector(self.rightButtonTaped), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        
        //APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self]
        
        //[numberPad.leftFunctionButton setTitle:@"B" forState:UIControlStateNormal]
        let rect = CGRectMake(0, SCREENHEIGHT-(SCREENWIDTH*0.75), SCREENWIDTH, (SCREENWIDTH*0.75))
        let numberPad = APNumberPad.init(delegate: self, withFrame:rect, displayLable:cashNumber)
        
        numberPad.leftFunctionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(numberPad)
        
        queryTcountState()
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
    
    //设置我要收银按钮
    /*
     func settingCashierDeskButton() {
     btnCashierDesk.layer.borderColor = UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1).CGColor
     btnCashierDesk.layer.borderWidth = 1
     btnCashierDesk.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1)), forState: .Highlighted)
     btnCashierDesk.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
     btnCashierDesk.clipsToBounds = true
     btnCashierDesk.layer.cornerRadius = SCREENWIDTH * 968 / 1242 / 4
     }
     */
    
    //我要收银
    //@IBAction func startCashier(sender: AnyObject) {
    //   self.performSegueWithIdentifier("toCalculater", sender: self)
    //}
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    
    func numberPad(numberPad: APNumberPad!, functionButtonAction functionButton: UIButton!, textInput: UIResponder!) {
        
    }
}


