//
//  MainController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/21.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class MainController: UIViewController , LauncherViewDelegate {

    @IBOutlet weak var btnCashIn: UIButton! //我要收银按钮
    @IBOutlet weak var launcherView: LauncherView! //启动项列表

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCashIn.layer.borderColor = UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1).CGColor
        btnCashIn.layer.borderWidth = 1
        btnCashIn.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1)), forState: .Highlighted)
        btnCashIn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btnCashIn.clipsToBounds = true
        btnCashIn.layer.cornerRadius = SCREENHEIGHT * 757 / 2208 * 2 / 3 / 2
        
        launcherView.delegate = self
        
        let titles = ["收银台" , "应用市场" , "我的应用" , "数据报表"  , ""]
        let icons = ["sytn" , "yyscn" , "wdyyn" , "sjbbn" , "addn" ]
        var items = [LauncherItem]()
        for i in 0..<titles.count {
            let item = LauncherItem(frame: CGRectZero, title: titles[i], image: icons[i], deletable: false)
            items.append(item)
        }
        launcherView .setPages(items, animated: false)
        
        loadUserInfo() //读取用户资料
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1)
        self.navigationController?.navigationBar.jh_setBackgroundColor(color)
        
        if let controller = self.parentViewController as? MenuViewController {
            controller.addPanGestureRecognizer()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
        
        if let controller = self.parentViewController as? MenuViewController {
            controller.removePanGestureRecognizer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //一进入页面进行数据读取，有2种情况：有和没有用户编号
    func loadUserInfo() {
        
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            
            let manager = AFNetworkingManager()
            manager.getRequest("user?token=\(token)", getData: nil, callback: {[weak self] (data, error) -> () in
                if var dic = data as? [String : AnyObject] {
                    print(dic)
                    if dic["errcode"] as? Int == 0 {
                        if let sign = dic["sign"] as? String {
                            let rsa = RSAHelper()
                            let result = rsa.rsaPDecrypt(sign, keyPath: DefaultKit.filePath("public_key.pem"))
                            let result2 = DefaultKit.validString(dic).md5
                            if result2 == result {
                                
                                if let data = dic["data"] as? String {
                                    let aes = AESHelper()
                                    let aes_key = NSUserDefaults.standardUserDefaults().objectForKey("aes_key") as? String
                                    let aesValue = aes.aes256_decrypt(aes_key!, hexString: data)
                                    print(aesValue)
                                }
                                
                            }else{
                                print("验签没通过")
                            }
                            
                        }
                    }else if dic["errcode"] as? Int > 0{
                        let errcode = dic["errcode"] as! Int
                        if errcode == 6 {
                            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                                let controller = self?.storyboard?.instantiateViewControllerWithIdentifier("navLogin")
                                appDelegate.window?.rootViewController = controller
                            }
                            
                            return
                        }
                        if let message = dic["msg"] as? String {
                            self?.view.makeToast(message)
                        }
                    }else{
                        self?.view.makeToast("网络故障")
                    }
                    
                }
            })
            
        }
        
    }
    
    
    //我要收银
    @IBAction func cashInPocket(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func launcherViewDidBeginEditing(sender: AnyObject) {
        
    }

    func launcherViewDidEndEditing(sender: AnyObject) {
        
    }
    
    func launcherViewItemSelected(item: LauncherItem) {
        
    }
    
}
