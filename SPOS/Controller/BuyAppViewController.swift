//
//  BuyAppViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/24.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class BuyAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var entryType = 1
    
    var buy_num = 1
    var permissionList:NSMutableArray!
    var showRoles:Bool = false
    
    var appDetail:AppItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        permissionList = NSMutableArray.init(capacity: 0)
        
        getPermisionList(appDetail.app_id)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //self.view.frame.origin
    }
    
    func stupSubViews() {
        
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        //let scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENHEIGHT - 64 - 60))
        //scrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*2)
        //scrollView.backgroundColor = UIColor.whiteColor()
        //scrollView.tag = 10
        //view.addSubview(scrollView)
        
        let appView = UIView(frame: CGRect(x: 10, y: 10, width: (SCREENWIDTH - 20) / 2, height: 100))
        //scrollView.addSubview(appView)
        
        let appImage = UIImageView(frame: CGRect(x: 10, y: 20, width: 70, height: 70))
        if let imagedata = NSData(contentsOfURL: NSURL(string: appDetail.app_logo)!){
            appImage.image = UIImage(data: imagedata)
        }
        appView.addSubview(appImage)
        
        let app_name = UILabel(frame: CGRect(x: 100, y: 20, width: 80, height: 15))
        app_name.text = appDetail.app_name
        app_name.font = UIFont.systemFontOfSize(15)
        appView.addSubview(app_name)
        
        let apt_name = UILabel(frame: CGRect(x: 100, y: 45, width: 80, height: 15))
        apt_name.text = appDetail.apt_name
        apt_name.font = UIFont.systemFontOfSize(10)
        apt_name.adjustsFontSizeToFitWidth = true
        apt_name.textColor = UIColor.darkGrayColor()
        appView.addSubview(apt_name)
        
        if(Int(appDetail.app_price) == 0){
            let app_price = UILabel(frame: CGRect(x: 100, y: 70, width: 30, height: 15))
            app_price.text = appDetail.app_fee
            app_price.textColor = UIColor.darkGrayColor()
            app_price.font = UIFont.systemFontOfSize(10)
            app_price.sizeToFit()
            appView.addSubview(app_price)
        }else{
            let app_price = UILabel(frame: CGRect(x: 100, y: 70, width: 30, height: 15))
            let fee_int = Int(appDetail.app_price)
            let fee_yuan:Float = Float(fee_int!) / 100
            app_price.text = String(fee_yuan)
            app_price.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
            app_price.font = UIFont.systemFontOfSize(15)
            app_price.sizeToFit()
            appView.addSubview(app_price)
            
            let app_feetype = UILabel(frame: CGRect(x: 130, y: 70, width: 30, height: 15))
            app_feetype.text = appDetail.getFeeType()
            app_feetype.textColor = UIColor.darkGrayColor()
            app_feetype.font = UIFont.systemFontOfSize(10)
            appView.addSubview(app_feetype)

        }
        //let tableView = UITableView(frame: CGRect(x: 0, y: 0 , width: SCREENWIDTH, height: SCREENHEIGHT))
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: SCREENHEIGHT - 64 - 60))
        
        tableView.registerClass(RolesTableViewCell.self, forCellReuseIdentifier: "RolesTableViewCell")
        tableView.separatorStyle  = .None
        tableView.tag = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = appView
        self.view.addSubview(tableView)
        
        let buttonView = UIView(frame:CGRect(x: 0, y:  SCREENHEIGHT - 60, width: SCREENWIDTH, height: 60))
        buttonView.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.1)
        view.addSubview(buttonView)

        let cancel = UIButton(frame: CGRect(x: 20, y: 8, width: SCREENWIDTH / 2 - 30, height: 44))
        cancel.setTitle("取消", forState: .Normal)
        cancel.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState: .Normal)
        cancel.titleLabel?.font = UIFont.systemFontOfSize(15)
        cancel.backgroundColor = UIColor.whiteColor()
        cancel.layer.cornerRadius = 5
        
        cancel.addTarget(self, action: #selector(BuyAppViewController.cancelButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonView.addSubview(cancel)
        
        let commit = UIButton(frame: CGRect(x: SCREENWIDTH / 2 + 10, y: 8, width: SCREENWIDTH / 2 - 30, height: 44))
        commit.setTitle("确定", forState: .Normal)
        commit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commit.titleLabel?.font = UIFont.systemFontOfSize(15)
        commit.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        commit.layer.cornerRadius = 5
        
        commit.addTarget(self, action: #selector(BuyAppViewController.commitButtionClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonView.addSubview(commit)

    }
    
    func cancelButtonClicked(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func commitButtionClicked(){
        
        let tableview = self.view.viewWithTag(100) as! UITableView
        
        if (tableview.numberOfSections == 2){
            
            for i in 0..<tableview.numberOfRowsInSection(1) {
                let index = NSIndexPath(forRow: i, inSection: 1)
                let cell = tableview.cellForRowAtIndexPath(index) as! RolesTableViewCell
                let role = self.permissionList[i] as? AppRoleItem
                if(cell.checked.on == true){
                    role?.checked = "1"
                }else{
                    role?.checked = "0"
                }
            }
        }else if(tableview.numberOfSections == 5){
            
            for i in 0..<tableview.numberOfRowsInSection(2) {
                let index = NSIndexPath(forRow: i, inSection: 2)
                let cell = tableview.cellForRowAtIndexPath(index) as! RolesTableViewCell
                let role = self.permissionList[i] as? AppRoleItem
                if(cell.checked.on == true){
                    role?.checked = "1"
                }else{
                    role?.checked = "0"
                }
            }
        }
        
        //获取拥有权限的角色信息
        var havePermissionRoles:Array<String> = Array()
        for i in 0..<permissionList.count{
            
            if let role = permissionList[i] as? AppRoleItem{
                if(role.checked == "1"){
                    havePermissionRoles.append(role.role_id)
                }
            }
        }
        
        //获取自动续费信息
        var isAuto = 0
        if(tableview.numberOfSections == 5){
            let autoBuy = self.view.viewWithTag(88) as? UISwitch
            if(autoBuy?.on == true){
                isAuto = 1
            }else{
                isAuto = 0
            }
        }
        
        //根据不同的界面业务提交请求
        if(typeOfView() != VIEWTYPE.TRY_WITH){
            
            let data = ["app_id":"\(appDetail.app_id)", "buy_num":"\(buy_num)", "auto_rebuy":"\(isAuto)", "roles": havePermissionRoles]
            
            let manager = AFNetworkingManager()
            manager.httpConnectRequst(self, urlString: "shopappstore/buy", postData: data, callback: { (data, error) in
                
                self.view.makeToast("应用购买成功")
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(BuyAppViewController.backScreen), userInfo: nil, repeats: false)
                
            })
            
        }else{
            let data = ["app_id":"\(appDetail.app_id)", "tryout":"1"]
            
            let manager = AFNetworkingManager()
            manager.httpConnectRequst(self, urlString: "shopappstore/buy", postData: data, callback: { (data, error) in
                
                self.view.makeToast("应用购买成功")
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(BuyAppViewController.backScreen), userInfo: nil, repeats: false)
                
            })
        }
        
    
    }
    
    func backScreen() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func getPermisionList(app_id:String){
        let data = ["app_id" : "\(app_id)"]
        let manager = AFNetworkingManager()
        manager.httpConnectRequstBackArray(self, urlString: "shopappstore/roles", postData: data) { (data, error) in
            TTGLog(data)
            if let rolelist = data as? NSArray{
                self.permissionList.removeAllObjects()
                for i in 0..<rolelist.count{
                    
                    let roleItem:AppRoleItem = AppRoleItem()
                    
                    if let tempRole = rolelist[i] as? [String : AnyObject]{
                        if let role_id = tempRole["role_id"] as? String{
                            roleItem.role_id = role_id
                        }
                        if let role_name = tempRole["role_name"] as? String{
                            roleItem.role_name = role_name
                        }
                        if let role_mct_no = tempRole["role_mct_no"] as? String{
                            roleItem.role_mct_no = role_mct_no
                        }
                        if let checked = tempRole["checked"] as? String{
                            roleItem.checked = checked
                        }
                    }
                    
                    self.permissionList.addObject(roleItem)

                }
                
            }
            self.stupSubViews()

        }
        
        
    }
    
    enum VIEWTYPE :Int{
        case FREE_BUY
        case FEE_BUY
        case TRY_WITH
        case NONE
    }
    
    func typeOfView() ->VIEWTYPE{
        if(entryType == 1) { // 续费进入的
            if(appDetail.app_pay_type == "0"){
                //是免费购买
                return VIEWTYPE.FREE_BUY
            }else{
                //花钱购买
                return VIEWTYPE.FEE_BUY
            }
        }else if(entryType == 2){ //试用进入的
            //试用
            return VIEWTYPE.TRY_WITH
        }else if(entryType == 3){ //购买进入的
            if(appDetail.app_pay_type != "0"){
                //购买
                return VIEWTYPE.FEE_BUY
            }else{
                //是免费购买
                return VIEWTYPE.FREE_BUY
            }
            
        }else{
            //什么都不是
            return VIEWTYPE.NONE
        }
        
    }

    
    // tablerview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //返回分区数
        if(typeOfView() == VIEWTYPE.FEE_BUY){
            return 5
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(typeOfView() == VIEWTYPE.FEE_BUY){
            if(section == 0){
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "开通时长"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let textView = UITextField(frame: CGRect(x: SCREENWIDTH - 80, y: 10, width: 30, height: 30))
                textView.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
                textView.text = "1"
                textView.keyboardType = .NumberPad
                textView.textAlignment = .Center
                textView.adjustsFontSizeToFitWidth = true
                textView.addTarget(self, action: #selector(BuyAppViewController.buy_time_changed(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
                textView.tag = 33
                buy_view.addSubview(textView)
                
                let type = UILabel(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 30, height: 30))
                type.textAlignment = NSTextAlignment.Right
                type.text = appDetail.getFeeType2()
                type.textColor = UIColor.darkGrayColor()
                type.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(type)
                return buy_view
                
            } else if (section == 1){
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "应用价格"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let price = UILabel(frame: CGRect(x: SCREENWIDTH - 90, y: 10, width: 50, height: 30))
                let fee_int = Int(appDetail.app_price)
                let fee_yuan:Float = Float(fee_int!) / 100
                price.text = String(fee_yuan)
                price.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
                //price.sizeToFit()
                price.adjustsFontSizeToFitWidth = true
                buy_view.addSubview(price)
                
                let type = UILabel(frame: CGRect(x: SCREENWIDTH - 70, y: 10, width: 50, height: 30))
                type.textAlignment = NSTextAlignment.Right
                type.text = appDetail.getFeeType()
                type.textColor = UIColor.darkGrayColor()
                type.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(type)
                return buy_view
                
            }else if (section == 2){
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "权限分配"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                
                let more = UIButton(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 30, height: 30))
                more.tag = 101
                more.setImage(UIImage(named: "0108"), forState: .Normal)
                more.addTarget(self, action: #selector(BuyAppViewController.showMoreRolePermission(_:)), forControlEvents:.TouchDown)
                buy_view.addSubview(more)
                return buy_view
                
            }else if(section == 3){
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "自动续费"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                
                let autoBuy = UISwitch(frame: CGRect(x: SCREENWIDTH - 80, y: 10, width: 60, height: 30))
                autoBuy.offImage = UIImage(named: "0012")
                autoBuy.onImage = UIImage(named: "0013")
                autoBuy.on = true
                autoBuy.tag = 88
                buy_view.addSubview(autoBuy)
                return buy_view
            }else{
                
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "总价"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let price = UILabel(frame: CGRect(x: SCREENWIDTH - 80, y: 10, width: 60, height: 30))
                let fee_int = Int(appDetail.app_price)
                let fee_yuan:Float = Float(fee_int! * self.buy_num) / 100
                price.textAlignment = NSTextAlignment.Right
                price.text = String(fee_yuan)
                price.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
                buy_view.addSubview(price)
                
                return buy_view

            }
            
            
        }else if(typeOfView() == VIEWTYPE.FREE_BUY){
            if(section == 0){
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "应用价格"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let type = UILabel(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 50, height: 30))
                type.text = "0.00"
                type.textColor = UIColor.darkGrayColor()
                type.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(type)
                return buy_view

            }else {
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "权限分配"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                
                let more = UIButton(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 30, height: 30))
                more.tag = 102
                more.setImage(UIImage(named: "0108"), forState: .Normal)
                more.addTarget(self, action: #selector(BuyAppViewController.showMoreRolePermission(_:)), forControlEvents:.TouchDown)
                buy_view.addSubview(more)
                return buy_view
            }
        }else {
            if(section == 0){
                
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "应用价格"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let type = UILabel(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 50, height: 30))
                
                type.text = appDetail.getFeeType()
                
                type.textColor = UIColor.darkGrayColor()
                type.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(type)
                return buy_view
                
            }else {
                let buy_view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
                
                let buy_time_string = UILabel(frame: CGRect(x: 20, y: 10, width: 80, height: 30))
                buy_time_string.text = "权限分配"
                buy_time_string.textColor = UIColor.darkGrayColor()
                buy_time_string.font = UIFont.systemFontOfSize(15)
                buy_view.addSubview(buy_time_string)
                
                let more = UIButton(frame: CGRect(x: SCREENWIDTH - 50, y: 10, width: 30, height: 30))
                more.tag = 103
                more.setImage(UIImage(named: "0108"), forState: .Normal)
                more.addTarget(self, action: #selector(BuyAppViewController.showMoreRolePermission(_:)), forControlEvents:.TouchDown)
                buy_view.addSubview(more)
                return buy_view
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //重新计算scollview的高度
        var height:CGFloat = 110.0
        var sectionNum:Int = 2
        if(typeOfView() == VIEWTYPE.FEE_BUY){
            sectionNum = 5
        }else{
            sectionNum = 2
        }
        if(sectionNum == 2){
            height = height + 50 * 2
            if showRoles == true{
                let rowNum = permissionList.count
                height = height + 50.0 * CGFloat(rowNum)
            }
        }else if (sectionNum == 5){
            height = height + 50 * 5
            if showRoles == true{
                let rowNum = permissionList.count
                height = height + 50.0 * CGFloat(rowNum)
            }
        }
        //计算scrollview的contentSize
        //let scrollview = self.view.viewWithTag(10) as! UIScrollView
        //scrollview.contentSize = CGSize(width: SCREENWIDTH, height: height)
        
        //计算tableView的contentSize
        //tableView.contentSize = CGSize(width: SCREENWIDTH, height: height)
        
        
        if(typeOfView() == VIEWTYPE.FEE_BUY){
            if(section == 2){
                if(showRoles == true){
                    return permissionList.count
                }else {
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if(section == 1){
                if(showRoles == true){
                    return permissionList.count
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if(typeOfView() == VIEWTYPE.FEE_BUY){
            if(indexPath.section == 2){
                let cell:RolesTableViewCell = tableView.dequeueReusableCellWithIdentifier("RolesTableViewCell") as! RolesTableViewCell
                
                if let role = self.permissionList[indexPath.row] as? AppRoleItem {
                    
                    cell.role_item = role
                    
                    cell.roleName.text = role.role_name
                    if(role.checked == "0"){
                        cell.checked.on = false
                    }else{
                        cell.checked.on = true
                    }
                }
                return cell
            }
        }else{
            if(indexPath.section == 1){
                let cell:RolesTableViewCell = tableView.dequeueReusableCellWithIdentifier("RolesTableViewCell") as! RolesTableViewCell
                if let role = self.permissionList[indexPath.row] as? AppRoleItem {
                    
                    cell.role_item = role
                    
                    cell.roleName.text = role.role_name
                    if(role.checked == "0"){
                        cell.checked.on = false
                    }else{
                        cell.checked.on = true
                    }
                }
                return cell
            }
        }
        return RolesTableViewCell()
    }
    
//    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
//        return false
//    }

    func buy_time_changed(sender: UITextField) {
        NSLog("buy_time_changed")
        if(sender.text != ""){
            self.buy_num = Int(sender.text!)!
        }else{
            self.buy_num = 1
            sender.text = "1"
        }
        sender.resignFirstResponder()
    }
    
    
    
   
    func showMoreRolePermission(sender:UIButton){
        
        TTGLog("showMoreRolePermission")
        if(showRoles == false){
            showRoles = true
        }else if (showRoles == true){
            showRoles = false
        }
        let tableview = self.view.viewWithTag(100) as! UITableView
        var sections:NSIndexSet!
        if(sender.tag == 101){
            sections = NSIndexSet(index: 2)
            
            for i in 0..<tableview.numberOfRowsInSection(2) {
                let index = NSIndexPath(forRow: i, inSection: 2)
                let cell = tableview.cellForRowAtIndexPath(index) as? RolesTableViewCell
                let role = self.permissionList[i] as? AppRoleItem
                if(cell != nil){
                    if(cell!.checked.on == true){
                        role?.checked = "1"
                    }else{
                        role?.checked = "0"
                    }
                }
            }
            
            
        }else{
            sections = NSIndexSet(index: 1)
            
            
            for i in 0..<tableview.numberOfRowsInSection(1) {
                let index = NSIndexPath(forRow: i, inSection: 1)
                let cell = tableview.cellForRowAtIndexPath(index) as? RolesTableViewCell
                let role = self.permissionList[i] as? AppRoleItem
                if(cell != nil){
                    if(cell!.checked.on == true){
                        role?.checked = "1"
                    }else{
                        role?.checked = "0"
                    }
                }
            }
            
        }
        tableview.reloadSections(sections, withRowAnimation:.Fade)
        
        //重新计算scollview的高度
        var height:CGFloat = 110.0
        let sectionNum = tableview.numberOfSections
        if(sectionNum == 2){
            height = height + 50 * 2
            if showRoles == true{
                let rowNum = tableview.numberOfRowsInSection(1)
                height = height + 50.0 * CGFloat(rowNum)
            }
        }else if (sectionNum == 5){
            height = height + 50 * 5
            if showRoles == true{
                let rowNum = tableview.numberOfRowsInSection(2)
                height = height + 50 * CGFloat(rowNum)
            }
        }
        //let scrollview = self.view.viewWithTag(10) as! UIScrollView
        //scrollview.contentSize = CGSize(width: SCREENWIDTH, height: height)

    }
    
}
