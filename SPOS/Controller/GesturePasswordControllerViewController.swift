//
//  GesturePasswordControllerViewController.swift
//  GesturePassword4Swift
//
//  Created by feiin on 14/11/22.
//  Copyright (c) 2014年 swiftmi. All rights reserved.
//

import UIKit

class GesturePasswordControllerViewController: UIViewController,VerificationDelegate,ResetDelegate,GesturePasswordDelegate {

    // 定义调用类型，1为进入app调用，3为系统管理关闭手势密码调用，4为系统管理打开手势密码调用, 5为系统管理修改手势密码
    var entryType:Int = 1
    
    var gesturePasswordView:GesturePasswordView!
    
    var previousString:String? = ""
    var password:String? = ""
    
    var secKey:String = "GesturePassword"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousString = ""
        //password = KeychainWrapper.stringForKey(secKey)
        password = NSUserDefaults.standardUserDefaults().stringForKey(SECKEY)
        
        if( password == "" || password == nil || entryType == 2){
            
            self.reset()
        }
        else{
            self.verify()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gesturePasswordCheckDeal(notification: NSNotification){
        
        let flagDic = notification.userInfo as! [String : Int]
        let flag = flagDic["flag"]
        if(flag == 1){
            //手势密码验证正确，进入主界面
            self.view.removeFromSuperview()
        }
    }
    func gesturePasswordModify(notification: NSNotification){
        
        let flagDic = notification.userInfo as! [String : Int]
        let flag = flagDic["flag"]
        if(flag == 5){
            reset()
        }
    }

    //MARK: - 验证手势密码
    func verify(){
        
        gesturePasswordView = GesturePasswordView(frame: UIScreen.mainScreen().bounds)
        gesturePasswordView.tentacleView!.rerificationDelegate = self
        // 定义调用类型，1为进入app调用，3为系统管理关闭手势密码调用，4为系统管理打开手势密码调用, 5为系统管理修改手势密码
        if(entryType == 1){
            gesturePasswordView.tentacleView!.style = 1
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GesturePasswordControllerViewController.gesturePasswordCheckDeal(_:)), name: "gesturePasswordCheckDeal", object: nil)

        }else if(entryType == 3){
            gesturePasswordView.tentacleView!.style = 3
        }else if(entryType == 4){
            gesturePasswordView.tentacleView!.style = 4
        }else if(entryType == 5){
            gesturePasswordView.tentacleView!.style = 5
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GesturePasswordControllerViewController.gesturePasswordModify(_:)), name: "gesturePasswordModify", object: nil)
        }
        gesturePasswordView.gesturePasswordDelegate = self
        
        //gesturePasswordView.backgroundColor = UIColor.grayColor()
        self.navigationItem.title = "验证手势密码"
        self.gesturePasswordView.state!.text = "请输入验证密码"
         self.gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
        
        self.view.addSubview(gesturePasswordView)
        
    }
    
    //MARK: - 重置手势密码
    func reset(){
        
        gesturePasswordView = GesturePasswordView(frame: UIScreen.mainScreen().bounds)
        gesturePasswordView.tentacleView!.resetDelegate = self
        gesturePasswordView.tentacleView!.style = 2
        gesturePasswordView.forgetButton!.hidden = true
         gesturePasswordView.changeButton!.hidden = true
        
        //self.navigationController?.navigationItem.title = "设置手势密码"
        self.navigationItem.title = "设置手势密码"
        self.gesturePasswordView.state!.text = "绘制图案"
        self.gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)

        self.view.addSubview(gesturePasswordView)
        
    }
    
    func exist()->Bool{
        
            //password = KeychainWrapper.stringForKey(secKey)
        NSUserDefaults.standardUserDefaults().stringForKey(SECKEY)
        if password == "" {
            return false
        }
        return true
    }
    
    //MARK: - 清空记录
    func clear(){
        
        //KeychainWrapper.removeObjectForKey(secKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SECKEY)
    }
    
    //MARK: - 改变手势密码
    func change(){
        
        print("改变手势密码")
        
    }
    
    //MARK: - 忘记密码
    func forget(){
          print("忘记密码")
    }
    
    
    func verification(result:String)->Bool{
        
       // println("password:\(result)====\(password)")
        if(result == password){
            
            gesturePasswordView.state!.textColor = UIColor.whiteColor()
            gesturePasswordView.state!.text = "输入正确"
            
            return true
        }
        gesturePasswordView.state!.textColor = UIColor.redColor()
        gesturePasswordView.state!.text = "手势密码错误"
        return false
    }
    
    func isfirstPassword(result:String) ->Bool{
        if(previousString == ""){
            return true
        }else{
            return false
        }
    }
    
    
    func resetPassword(result: String) -> Bool {
    
        if(previousString == ""){
            previousString = result
            gesturePasswordView.tentacleView!.enterArgin()
            gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
            gesturePasswordView.state!.text = "请再次输入验证密码"
            
            return true
        }else{
            
            if(result == previousString){
                
               
              
                //KeychainWrapper.setString(result, forKey: secKey)
                NSUserDefaults.standardUserDefaults().setObject(result, forKey: SECKEY)
                
                gesturePasswordView.state!.textColor = UIColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 1)
                gesturePasswordView.state!.text = "已保存手势密码"
                
                
            
                return true;
            }else{
                previousString = "";
                gesturePasswordView.state!.textColor = UIColor.redColor()
                gesturePasswordView.state!.text = "两次密码不一致，请重新输入"
                
                return false
            }
            
        }
    }
    
 

}
