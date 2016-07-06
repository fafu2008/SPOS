//
//  PaySuccessController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/8.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class PaySuccessController: UIViewController {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblCunsomMoney: UILabel!
    @IBOutlet weak var lblCouponMoney: UILabel!
    @IBOutlet weak var lblAccruedMoney: UILabel!
    @IBOutlet weak var lblDiscountMoney: UILabel!
    @IBOutlet weak var lblIntegral: UILabel!
    
    let cdOrder = CDOrder()
    
    var dic:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PaySuccessController.back))
        button.image = UIImage.init(named: "back")
        
        let spacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = -10
        
        if (self.dic != nil)
        {
            print(self.dic)
            lblOrderNo.text = self.dic!["ord_no"] as? String
            query_order_detail(lblOrderNo.text!)
        }
        
        self.navigationItem.leftBarButtonItems = [spacer,button]
        // Do any additional setup after loading the view.
    }
    
    //add by yushaopeng
    func back()
    {
        let controller = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.jh_setBackgroundColor(BASE_UICOLOR)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func query_order_detail(ord_id:String)
    {
        let data : [String : AnyObject] = ["ord_no" : ord_id]
        //let data : [String : AnyObject] = ["page" : "1","pagesize" : "9"]
        let (token , param) = DefaultKit.packageParam(data)
        
        if (param == nil)
        {
            print("query_order_detail error")
            return
        }
        
        let manager = AFNetworkingManager()
        manager.postRequest("order/view?token=\(token!)", postData: param, callback: {[weak self] (dic, error) in
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
                                        self!.lblCunsomMoney.text = DefaultKit.change_string_to_float(dic1["original_amount"] as! String)
                                        self!.lblCouponMoney.text = DefaultKit.change_string_to_float(dic1["discount_amount"] as! String)
                                        self!.lblAccruedMoney.text = DefaultKit.change_string_to_float(dic1["trade_amount"] as! String)
                                        
                                        self!.cdOrder.insertNewOrder("Order", dic: dic1)
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
    //end add

    //支付成功并返回
    @IBAction func payFinishedToBack(sender: AnyObject) {
        let controller = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
