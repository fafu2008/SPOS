//
//  ConsumeRevokeController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ConsumeRevokeController: UIViewController {
    
    
    @IBOutlet weak var tfPWD: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //提交主管密码
    @IBAction func submitManagePWD(sender: AnyObject) {
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
