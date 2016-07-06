//
//  AppDetailViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {
    
    
    @IBOutlet var app_pay_type_con: NSLayoutConstraint!
    
    var is_buy:Bool = false
 
    var appDetail:AppItem = AppItem()
    
    @IBOutlet var app_datail_view: UIView!
    @IBOutlet var app_buy_info: UIView!
    
    var current_page = 1
    
    @IBOutlet var app_ver_intro: UIButton!
    @IBOutlet var app_notes: UIButton!
    @IBOutlet var app_pictures: UIButton!
    
    @IBOutlet var app_notes_imagebar: UIImageView!
    @IBOutlet var app_picture_imagebar: UIImageView!
    @IBOutlet var app_ver_intro_imagebar: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var apt_name2: UILabel!
    @IBOutlet var app_type: UILabel!
    @IBOutlet var dev_name: UILabel!
    @IBOutlet var app_ver: UILabel!
    @IBOutlet var ver_upd_time: UILabel!
    
    
    
    
    
    @IBOutlet var buy_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  
        //设置进入应用按钮的圆角效果
        buy_button.layer.masksToBounds = true
        buy_button.layer.cornerRadius = 5
        buy_button.addTarget(self, action: #selector(AppDetailViewController.entryAppButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载数据
        getAppDetail(appDetail.app_id)
        
    }
    

    
    func entryAppButtonClicked(){
        MyAppsViewController.entryApp(self,app_id: appDetail.app_id)
    }
    
    
    func getAppDetail(app_id:String) {
        let data = ["app_id" : "\(app_id)"]
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(self, urlString: "/shopappstore/detail", postData: data) { (data, error) in
            //TTGLog(data)
            if let app_id = data!["app_id"] as? String{
                self.appDetail.app_id = app_id
            }
            if let app_intro = data!["app_intro"] as? String{
                self.appDetail.app_intro = app_intro
            }
            if let app_logo = data!["app_logo"] as? String{
                self.appDetail.app_logo = app_logo
            }
            if let app_name = data!["app_name"] as? String{
                self.appDetail.app_name = app_name
            }
            if let app_pay_type = data!["app_pay_type"] as? String{
                self.appDetail.app_pay_type = app_pay_type
            }
            if let app_price = data!["app_price"] as? String{
                self.appDetail.app_price = app_price
                let fee_int = Int(app_price)
                let fee_yuan:Float = Float(fee_int!) / 100
                let fee_string = String(fee_yuan)
                if let fee_type = data!["app_pay_type"] as? String{
                    switch fee_type {
                    case "0":
                        self.appDetail.app_fee = "免费"
                    case "1":
                        self.appDetail.app_fee = fee_string + "元/天"
                    case "2":
                        self.appDetail.app_fee = fee_string + "元/周"
                    case "3":
                        self.appDetail.app_fee = fee_string + "元/月"
                    case "4":
                        self.appDetail.app_fee = fee_string + "元/季度"
                    case "5":
                        self.appDetail.app_fee = fee_string + "元/年"
                    case "6":
                        self.appDetail.app_fee = fee_string + "元/次"
                    default:
                        self.appDetail.app_fee = "免费"
                    }
                }
            }
            if let app_size = data!["app_size"] as? String{
                self.appDetail.app_size = app_size
            }
            if let app_tryout = data!["app_tryout"] as? String{
                self.appDetail.app_tryout = app_tryout
            }
            if let app_type = data!["app_type"] as? String{
                self.appDetail.app_type = app_type
            }
            if let app_ver = data!["app_ver"] as? String{
                self.appDetail.app_ver = app_ver
            }
            if let app_ver_id = data!["app_ver_id"] as? String{
                self.appDetail.app_ver_id = app_ver_id
            }
            if let apt_id = data!["apt_id"] as? String{
                self.appDetail.apt_id = apt_id
            }
            if let apt_name = data!["apt_name"] as? String{
                self.appDetail.apt_name = apt_name
            }
            if let dev_id = data!["dev_id"] as? String{
                self.appDetail.dev_id = dev_id
            }
            if let dev_name = data!["dev_name"] as? String{
                self.appDetail.dev_name = dev_name
            }
            if let sap_ver_id = data!["sap_ver_id"] as? String{
                self.appDetail.sap_ver_id = sap_ver_id
            }
            if let ver_intro = data!["ver_intro"] as? String{
                self.appDetail.ver_intro = ver_intro
            }
            if let ver_photos = data!["ver_photos"] as? NSArray{
                self.appDetail.ver_photos = ver_photos
            }
            if let ver_upd_time = data!["ver_upd_time"] as? String{
                self.appDetail.ver_upd_time = ver_upd_time
            }
            if let sap_expired_date = data!["sap_expired_date"] as? String{
                self.appDetail.sap_expired_date = sap_expired_date
            }
            if let sap_expired_days = data!["sap_expired_days"] as? String{
                self.appDetail.sap_expired_days = sap_expired_days
            }
            
            self.stupSubView()
        }
        
    }
    
   
    
    
    
    func stupSubView(){
        TTGLog("stupSubView")
        
        let appView = UIView(frame: self.app_datail_view.frame)
        self.app_datail_view.addSubview(appView)
        
        let appImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 65, height: 65))
        if let imagedata = NSData(contentsOfURL: NSURL(string: appDetail.app_logo)!){
            appImage.image = UIImage(data: imagedata)
        }
        app_datail_view.addSubview(appImage)
        
        let app_name = UILabel(frame: CGRect(x: 80, y: 20, width: 100, height: 15))
        app_name.text = appDetail.app_name
        app_name.font = UIFont.systemFontOfSize(15)
        app_datail_view.addSubview(app_name)
        
        let apt_name = UILabel(frame: CGRect(x: 80, y: 45, width: 120, height: 15))
        apt_name.text = appDetail.apt_name
        apt_name.font = UIFont.systemFontOfSize(10)
        apt_name.textColor = UIColor.darkGrayColor()
        app_datail_view.addSubview(apt_name)
        
        if(Int(appDetail.app_price) == 0){
            let app_price = UILabel(frame: CGRect(x: 80, y: 70, width: 30, height: 15))
            app_price.text = appDetail.app_fee
            app_price.textColor = UIColor.darkGrayColor()
            app_price.font = UIFont.systemFontOfSize(10)
            app_price.sizeToFit()
            //app_price.adjustsFontSizeToFitWidth = true
            app_datail_view.addSubview(app_price)
        }else{
            let app_price = UILabel(frame: CGRect(x: 80, y: 70, width: 30, height: 15))
            let fee_int = Int(appDetail.app_price)
            let fee_yuan:Float = Float(fee_int!) / 100
            app_price.text = String(fee_yuan)
            app_price.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
            app_price.font = UIFont.systemFontOfSize(13)
            app_price.sizeToFit()
            app_datail_view.addSubview(app_price)
            
            let app_feetype = UILabel(frame: CGRect(x: 110, y: 70, width: 30, height: 15))
            app_feetype.text = appDetail.getFeeType()
            app_feetype.textColor = UIColor.darkGrayColor()
            app_feetype.font = UIFont.systemFontOfSize(10)
            app_datail_view.addSubview(app_feetype)
            
        }
        

        
        apt_name2.text = appDetail.apt_name
        app_type.text = "电脑端,客服端"
        dev_name.text = appDetail.dev_name
        app_ver.text = appDetail.app_ver
        ver_upd_time.text = appDetail.ver_upd_time
        
        for tempview in app_buy_info.subviews{
            tempview.removeFromSuperview()
        }
        
        //版本号不为空，说明已经购买的应用
        if((appDetail.sap_ver_id != "") || (!(appDetail.sap_ver_id.isEmpty))){
            
            let sap_expired_time_label:UILabel = UILabel(frame: CGRect(x: 15, y: 10, width: 50, height: 10))
            sap_expired_time_label.text = "过期时间:"
            sap_expired_time_label.font = UIFont.systemFontOfSize(10)
            sap_expired_time_label.textColor = UIColor.grayColor()
            self.app_buy_info.addSubview(sap_expired_time_label)
            
            let sap_expired_time_value:UILabel = UILabel(frame: CGRect(x: 60, y: 10, width: 80, height: 10))
            sap_expired_time_value.text = appDetail.sap_expired_date
            sap_expired_time_value.font = UIFont.systemFontOfSize(10)
            sap_expired_time_value.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
            self.app_buy_info.addSubview(sap_expired_time_value)
            
            let valiable_days_label:UILabel = UILabel(frame: CGRect(x: 15, y: 30, width: 50, height: 10))
            valiable_days_label.text = "剩余天数"
            valiable_days_label.font = UIFont.systemFontOfSize(10)
            valiable_days_label.textColor = UIColor.grayColor()
            self.app_buy_info.addSubview(valiable_days_label)
            
            let valiable_days_value:UILabel = UILabel(frame: CGRect(x: 60, y: 30, width: 80, height: 10))
            valiable_days_value.text = appDetail.sap_expired_days
            valiable_days_value.font = UIFont.systemFontOfSize(10)
            valiable_days_value.textColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
            self.app_buy_info.addSubview(valiable_days_value)
            
            
            let renewButton:UIButton = UIButton(frame:CGRect(x:15, y: valiable_days_value.frame.maxY + 10, width:self.app_buy_info.frame.width - 50, height: 35))
            renewButton.backgroundColor = UIColor.whiteColor()
            renewButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            renewButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Normal)
            renewButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 0.5), forState:UIControlState.Highlighted)
            renewButton.setTitle("充值续费", forState: UIControlState.Normal)
            
            renewButton.layer.masksToBounds = true
            renewButton.layer.cornerRadius = 5
            renewButton.layer.borderWidth = 1
            renewButton.layer.borderColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0).CGColor
            renewButton.addTarget(self, action: #selector(renewClicked(button:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.app_buy_info.addSubview(renewButton)
            
            buy_button.hidden = false
            
        }else{
            
            let tryWithButton:UIButton = UIButton(frame:CGRect(x:15, y: 10, width:self.app_buy_info.frame.width - 50, height: 35))
            tryWithButton.backgroundColor = UIColor.whiteColor()
            tryWithButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            tryWithButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Normal)
            tryWithButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 0.5), forState:UIControlState.Highlighted)
            tryWithButton.setTitle("免费试用", forState: UIControlState.Normal)
            
            tryWithButton.layer.masksToBounds = true
            tryWithButton.layer.cornerRadius = 5
            tryWithButton.layer.borderWidth = 1
            tryWithButton.layer.borderColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0).CGColor
            tryWithButton.addTarget(self, action: #selector(tryWithClicked(button:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.app_buy_info.addSubview(tryWithButton)
            
            let buyAppButton:UIButton = UIButton(frame:CGRect(x:15, y: tryWithButton.frame.maxY + 10, width:self.app_buy_info.frame.width - 50, height: 35))
            buyAppButton.backgroundColor = UIColor.whiteColor()
            buyAppButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            buyAppButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Normal)
            buyAppButton.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 0.5), forState:UIControlState.Highlighted)
            buyAppButton.setTitle("购买应用", forState: UIControlState.Normal)
            
            buyAppButton.layer.masksToBounds = true
            buyAppButton.layer.cornerRadius = 5
            buyAppButton.layer.borderWidth = 1
            buyAppButton.layer.borderColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0).CGColor
            buyAppButton.addTarget(self, action: #selector(buyAppClicked(button:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.app_buy_info.addSubview(buyAppButton)
            
            buy_button.hidden = true
            
        }
        
        app_pictures.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Selected)
        app_pictures.selected = true
        app_picture_imagebar.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        
        app_notes.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Selected)
        app_notes.selected = false
        app_notes_imagebar.backgroundColor = UIColor.lightGrayColor()
        
        app_ver_intro.setTitleColor(UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0), forState:.Selected)
        app_ver_intro_imagebar.backgroundColor = UIColor.lightGrayColor()
        app_ver_intro.selected = false
        
        current_page = 1
        
        stupScrollView(current_page)
    }
    
    
    func renewClicked(button button : UIButton){
        TTGLog("renewClicked")
        
        let buyAppController = (self.storyboard?.instantiateViewControllerWithIdentifier("buyappview"))! as! BuyAppViewController
        buyAppController.appDetail = appDetail
        buyAppController.entryType = 1
        self.navigationController?.pushViewController(buyAppController, animated: true)
        
    }
    
    func tryWithClicked(button button : UIButton){
        TTGLog("tryWithClicked")
        
        let buyAppController = (self.storyboard?.instantiateViewControllerWithIdentifier("buyappview"))! as! BuyAppViewController
        buyAppController.appDetail = appDetail
        buyAppController.entryType = 2
        self.navigationController?.pushViewController(buyAppController, animated: true)
        
    }
    
    func buyAppClicked(button button : UIButton){
        TTGLog("buyAppClicked")
        
        let buyAppController = (self.storyboard?.instantiateViewControllerWithIdentifier("buyappview"))! as! BuyAppViewController
        buyAppController.appDetail = appDetail
        buyAppController.entryType = 3
        self.navigationController?.pushViewController(buyAppController, animated: true)
        
    }
    
    
    @IBAction func app_pictures_clicked(sender: UIButton) {
        
        current_page  = 1
        
        app_pictures.selected = true
        app_picture_imagebar.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        
        app_notes.selected = false
        app_notes_imagebar.backgroundColor = UIColor.lightGrayColor()
        
        app_ver_intro_imagebar.backgroundColor = UIColor.lightGrayColor()
        app_ver_intro.selected = false
        
        stupScrollView(current_page)

        
    }
    @IBAction func app_notes_clicked(sender: UIButton) {
        
        current_page  = 2

        app_pictures.selected = false
        app_picture_imagebar.backgroundColor = UIColor.lightGrayColor()
        
        app_notes.selected = true
        app_notes_imagebar.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        
        app_ver_intro_imagebar.backgroundColor = UIColor.lightGrayColor()
        app_ver_intro.selected = false
        
        stupScrollView(current_page)

    }
    @IBAction func app_ver_intro_clicked(sender: UIButton) {
        
        current_page  = 3

        app_pictures.selected = false
        app_picture_imagebar.backgroundColor = UIColor.lightGrayColor()
        
        app_notes.selected = false
        app_notes_imagebar.backgroundColor =  UIColor.lightGrayColor()
        
        app_ver_intro_imagebar.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        app_ver_intro.selected = true
        
        stupScrollView(current_page)
        
    }
    
    func stupScrollView(currentPage: Int){
        
        for tempview in scrollView.subviews{
            tempview.removeFromSuperview()
        }
        
        scrollView.backgroundColor = UIColor.whiteColor()
        
        if(currentPage == 1){
            
            NSThread.detachNewThreadSelector(#selector(AppDetailViewController.downloadAppPicture), toTarget: self, withObject: nil);
            
        }else if(currentPage == 2) {
            
            scrollView.pagingEnabled  = true
            scrollView.bounces = true
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = false

            let notes = UITextView(frame: CGRect(x: 20, y: 10, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20))
            
            notes.font = UIFont.systemFontOfSize(12)
            notes.textColor = UIColor.darkGrayColor()
            notes.text = appDetail.app_intro
            notes.editable = false
            notes.selectable = false
            scrollView.addSubview(notes)
            
        }else if(currentPage == 3) {
            
            scrollView.pagingEnabled  = true
            scrollView.bounces = true
            scrollView.alwaysBounceVertical = true
            scrollView.alwaysBounceHorizontal = false

            let vernotes = UITextView(frame: CGRect(x: 20, y: 10, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20))
            
            vernotes.font = UIFont.systemFontOfSize(12)
            vernotes.textColor = UIColor.darkGrayColor()
            vernotes.text = appDetail.ver_intro
            vernotes.editable = false
            vernotes.selectable = false
            scrollView.addSubview(vernotes)
            
        }
        
        
    }
    
    func downloadAppPicture(){
        
            let count = appDetail.ver_photos.count
            
            scrollView.pagingEnabled  = true
            scrollView.bounces = true
            scrollView.alwaysBounceHorizontal = true
            scrollView.alwaysBounceVertical = false
            
            scrollView.contentSize = CGSize(width: (self.view.frame.width / 3 + 20) * CGFloat(count), height: scrollView.frame.height)
        
            for i in 0..<count{
                
                let appImageView = UIImageView(frame: CGRect(x: 20 + CGFloat(i) * (self.view.frame.width  / 3 + 20), y: 10, width: self.view.frame.width  / 3, height: scrollView.frame.height - 15))
                
                if let imagedata = NSData(contentsOfURL: NSURL(string: appDetail.ver_photos[i] as! String)!){
                    
                    appImageView.image = UIImage(data: imagedata)
                    
                }
                
                scrollView.addSubview(appImageView)

                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(AppDetailViewController.appPictureClicked(_:)))
                tapgesture.numberOfTapsRequired = 1
                
                appImageView.addGestureRecognizer(tapgesture)
                
                
            }
            
            
        }
    
    
    
    func appPictureClicked(sender:UITapGestureRecognizer){
        
        TTGLog("appPictureClicked")
    }
    
    
    
    
}
