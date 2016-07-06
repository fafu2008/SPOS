//
//  ForgetPWDController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/3/27.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ForgetPWDController: UIViewController {

    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfSMSCode: UITextField!
    @IBOutlet weak var tfNewPWD: UITextField!
    @IBOutlet weak var tfRNewPWD: UITextField!
    @IBOutlet weak var btnMobileClear: UIButton!
    @IBOutlet weak var btnSMSCode: UIButton!
    @IBOutlet weak var btnNewPWDClear: UIButton!
    @IBOutlet weak var btnRNewPWDClear: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.jh_setBackgroundColor(UIColor(red: 1 , green: 96/255.0 , blue : 0 , alpha : 1))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.jh_alphaReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Action
    //清空输入框的内容
    @IBAction func clearTextField(sender: AnyObject) {
        
    }
    
    //获取验证码
    @IBAction func getSMSCode(sender: AnyObject) {
        
    }
    
    //提交
    @IBAction func submit(sender: AnyObject) {
        
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
