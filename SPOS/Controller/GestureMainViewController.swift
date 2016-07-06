//
//  GestureMainViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/10.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

var SECKEY:String = "GesturePassword"

class GestureMainViewController: UITableViewController {

    var isOpenGesture:Int = 0
    
    @IBOutlet var isOpenGestureSwich: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        var isOpenGestureStr:Int = 10
        isOpenGestureStr = NSUserDefaults.standardUserDefaults().integerForKey("is_open_gesture")
        if(isOpenGestureStr == 1) {
            isOpenGesture = 1
            isOpenGestureSwich.on = true
        }else{
            isOpenGestureSwich.on = false
            isOpenGesture = 0
            NSUserDefaults.standardUserDefaults().setInteger(isOpenGesture, forKey: "is_open_gesture")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GestureMainViewController.gesturePasswordCheckDeal(_:)), name: "gesturePasswordCheckDeal", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        var isOpenGestureStr:Int = 10
        isOpenGestureStr = NSUserDefaults.standardUserDefaults().integerForKey("is_open_gesture")
        if(isOpenGestureStr == 1) {
            isOpenGesture = 1
            isOpenGestureSwich.on = true
        }else{
            isOpenGestureSwich.on = false
            isOpenGesture = 0
            NSUserDefaults.standardUserDefaults().setInteger(isOpenGesture, forKey: "is_open_gesture")
        }
        
    }
    
    
    @IBAction func ifOpenGestureValueChanged(sender: UISwitch) {

        let gestureContronller = GesturePasswordControllerViewController()
        if(sender.on == true){
            gestureContronller.entryType = 2 //打开手势密码
        }else{
            gestureContronller.entryType = 4 //关闭手势密码
        }
        self.navigationController?.pushViewController(gestureContronller, animated: true)
    }
    
    func gesturePasswordCheckDeal(notification: NSNotification){
        let flagDic = notification.userInfo as! [String : Int]
        let flag = flagDic["flag"]
        if(flag == 3){
            isOpenGesture = 1
        }
        if(flag == 4){
            isOpenGesture = 0
            NSUserDefaults.standardUserDefaults().removeObjectForKey(SECKEY)
        }
        if(flag == 2){
            isOpenGesture = 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(isOpenGesture, forKey: "is_open_gesture")
        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if(section == 1){
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 30))
            let label = UILabel(frame: CGRect(x: 20, y: 10, width: SCREENWIDTH - 20, height: 15))
            label.text = "开启手势密码，退出应用会进行锁屏验证."
            label.textColor = UIColor.grayColor()
            label.font = UIFont.systemFontOfSize(15)
            view.addSubview(label)
            return view
        }
        return nil
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if(isOpenGesture == 0){
            return 1
        }else if(isOpenGesture == 1){
            return 2
        }
        return 1
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1){
            let gestureContronller = GesturePasswordControllerViewController()
            gestureContronller.entryType = 5 //修改手势密码
            self.navigationController?.pushViewController(gestureContronller, animated: true)
        }
    }


}
