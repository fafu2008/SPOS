//
//  ScanHelpController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/15.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class ScanHelpController: UIViewController {

    @IBOutlet weak var btnKnowledge: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnKnowledge.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 1, green: 96/255.0, blue: 0, alpha: 1)), forState: .Normal)
        btnKnowledge.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 179/255.0, green: 62/255.0, blue: 15/255.0, alpha: 1)), forState: .Highlighted)
        btnKnowledge.layer.cornerRadius = 10
        btnKnowledge.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //知道了扫码规则
    @IBAction func knowledgeHelp(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
