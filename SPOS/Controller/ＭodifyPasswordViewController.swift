//
//  ＭodifyPasswordViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/9.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ModifyPasswordViewController: UIViewController {

    @IBOutlet var oldPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var newCommitPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func oldPasswordEditChanged(sender: UITextField) {
        let pswString:NSString = sender.text!
        if(pswString.length > 6){
            //oldPassword.text = pswString.substringToIndex(6)
        }
    }
 
    @IBAction func newPasswordEditChanged(sender: UITextField) {
        let pswString:NSString = sender.text!
        if(pswString.length > 6){
            //newPassword.text = pswString.substringToIndex(6)
        }
    }

    
    @IBAction func newCommitPasswordChanged(sender: UITextField) {
        let pswString:NSString = sender.text!
        if(pswString.length > 6){
           // newCommitPassword.text = pswString.substringToIndex(6)
        }
    }

    @IBAction func commitChangePassword(sender: UIBarButtonItem) {

        var psw:NSString = oldPassword.text!
        
        if(psw.length < 1){
            UIAlertView(title: "提示", message: "请正确的原密码", delegate: nil, cancelButtonTitle: "知道了").show()
            return
        }
        
        psw = newPassword.text!
        
        if(CheckUserInput.validatePassword(psw as String) == false){
            UIAlertView(title: "提示", message: "请输入6位以上数字、字母组合", delegate: nil, cancelButtonTitle: "知道了").show()
            return
        }
        if(newPassword.text != newCommitPassword.text){
            UIAlertView(title: "提示", message: "两次密码输入不一致", delegate: nil, cancelButtonTitle: "知道了").show()
            return
        }
        modifyPassword()

    }
    
    func modifyPassword(){
        do{
            self.view.showHUD()
            if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
                let old_psw:String = oldPassword.text!
                let new_psw:String = newPassword.text!
                let data = ["old_password" : "\(old_psw.sha1())","password":"\(new_psw.sha1())"]
                print("data=\(data)")
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
                    manager.postRequest("/admin/password?token=\(token)", postData: ["sign" : sign,"data" : aes_string], callback: { (dic, err) in
                        if let value = dic as? [String : AnyObject] {
                            
                            self.view.dismissHUD()
                            print(value)
                            
                            if value["errcode"] as? Int == 0 {
                                
                                self.view.makeToast("修改密码成功")
                                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ModifyPasswordViewController.backScreen), userInfo: nil, repeats: false)
                                
                            }else if value["errcode"] as? Int > 0 {
                            
                                self.view.makeToast(value["msg"] as? String)
                            
                            }else{
                                
                            }
                        }
                    })
                }
            }
            
        }
        catch
        {
            self.view.dismissHUD()
            print("TCountTransRecord解析异常")
        }
    }
    
    func backScreen() {
        self.navigationController?.popViewControllerAnimated(true)
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
