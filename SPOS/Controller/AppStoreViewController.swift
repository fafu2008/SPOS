//
//  AppStoreViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/16.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class AppStoreViewController: UIViewController ,SimpleAppCellProtocol{

    var currentPage = 1
    var totalPage = 1
    
    var appArray : NSMutableArray?  {
        
        didSet {
            
            //createAppItemViews()
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        self.appArray = NSMutableArray.init(capacity: 0)

        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppStoreViewController.AppItemClick(_:)), name: "AppItemClickEvent", object: nil)
        
        let leftgesture = UISwipeGestureRecognizer(target: self, action: #selector(AppStoreViewController.viewSwipe(_:)))
        leftgesture.direction = .Left
        self.view.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: #selector(AppStoreViewController.viewSwipe(_:)))
        rightgesture.direction = .Right
        self.view.addGestureRecognizer(rightgesture)
        
        getAppItemList(1)

        // Do any additional setup after loading the view.
    }

    func viewSwipe(sender:UISwipeGestureRecognizer){
        if(sender.direction == .Right){
            if(currentPage > 1){
                getAppItemList(currentPage - 1)
            }else {
                self.view.makeToast("没有上一页了")
            }
        }
        if(sender.direction == .Left){
            if(currentPage < totalPage){
                getAppItemList(currentPage + 1)
            }else {
                self.view.makeToast("没有下一页了")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("viewWillAppear")
    }
    

    func createAppItemViews(){
        for subview in self.view.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        if let count = appArray?.count{
            
            for i in 0..<count{
                
                let row:Int = i/3
                let column:Int = i%3
                
                let tempApp:AppItem = appArray![i] as! AppItem
                
                let _x = (80 * CGFloat(column) + ((self.view.bounds.width / 4 - 60) * (CGFloat(column) + 1)))
                let _y = ((self.view.bounds.height / 4) - 110) * (CGFloat(row) + 1) + (110 * CGFloat(row)) + 64
                let app = SimpleAppCell(frame: CGRectMake(_x, _y, 80, 110) ,appItem: tempApp)
                
                app.delegate = self
                self.view.addSubview(app)
                
            }
        }
        
        
        if(appArray?.count == 0){
            
            let empty:UILabel = UILabel(frame: CGRect(x: 50, y: 250, width: self.view.bounds.width - 100 , height: 50))
            empty.contentMode = UIViewContentMode.Center
            empty.textAlignment = NSTextAlignment.Center
            empty.textColor = UIColor.grayColor()
            empty.font = UIFont.systemFontOfSize(20)
            empty.text = "还没有应用"
            self.view.addSubview(empty)
            
        }else{
            
            let pageView = AppStorePageView(frame: CGRectMake((self.view.bounds.width - 200)/2, self.view.bounds.height - 50 , 200, 25), currentPage: self.currentPage, totalPage: self.totalPage)
            
            pageView.left.addTarget(self, action: #selector(AppStoreViewController.previousClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
            pageView.right.addTarget(self, action: #selector(AppStoreViewController.nextClicked), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(pageView)
            
        }
        
    }
    
    
    func previousClicked(){
        if(currentPage > 1){
            getAppItemList(currentPage - 1)
        }else {
            self.view.makeToast("没有上一页了")
        }
    }
    func nextClicked(){
        if(currentPage < totalPage){
            getAppItemList(currentPage + 1)
        }else {
            self.view.makeToast("没有下一页了")
        }
    }
    
    
    
    // MARK: - Navigation


    func getAppItemList(currentPage:Int){
        let data = ["app_size" : "3","app_type":"1,4","page":"\(currentPage)","pagesize":"9"]
        let manager = AFNetworkingManager()
        manager.httpConnectRequst(self, urlString: "/shopappstore", postData: data) { (data, error) in
            print(data)
            if let pages = data!["pages"] as? [String : AnyObject]{
                if let totalnum = pages["totalpage"] as? Int {
                    self.totalPage = totalnum
                }
                
                if let curr = pages["page"] as? Int {
                    self.currentPage = curr
                }
            }
            if let applist = data!["list"] as? NSArray{
                self.appArray?.removeAllObjects()
                for i in 0..<applist.count{
                    
                    let appItem:AppItem = AppItem()
                    
                    if let tempApp = applist[i] as? [String : AnyObject]{
                        if let name = tempApp["app_name"] as? String{
                            appItem.app_name = name
                        }
                        if let id = tempApp["app_id"] as? String{
                            appItem.app_id = id
                        }
                        if let image = tempApp["app_logo"] as? String{
                            appItem.app_logo = image
                        }
                        if let tpye = tempApp["apt_name"] as? String{
                            appItem.apt_name = tpye
                        }
                        
                        if let fee = tempApp["app_price"] as? String{
                            let fee_int = Int(fee)
                            let fee_yuan:Float = Float(fee_int!) / 100
                            let fee_string = String(fee_yuan)
                            if let fee_type = tempApp["app_pay_type"] as? String{
                                switch fee_type {
                                case "0":
                                    appItem.app_fee = "免费"
                                case "1":
                                    appItem.app_fee = fee_string + "元/天"
                                case "2":
                                    appItem.app_fee = fee_string + "元/周"
                                case "3":
                                    appItem.app_fee = fee_string + "元/月"
                                case "4":
                                    appItem.app_fee = fee_string + "元/季度"
                                case "5":
                                    appItem.app_fee = fee_string + "元/年"
                                case "6":
                                    appItem.app_fee = fee_string + "元/次"
                                default:
                                    appItem.app_fee = "免费"
                                }
                            }
                        }
                        if let introduce = tempApp["app_intro"] as? String{
                            appItem.app_intro = introduce
                        }
                    }
                    
                    self.appArray?.addObject(appItem)

                }
                self.createAppItemViews()
            }
        }

    }
    
    func simpleAppDidClicked(appid : String){
        NSLog("simpleAppDidClicked")
        
        let appDetailController = (self.storyboard?.instantiateViewControllerWithIdentifier("appdetail"))! as! AppDetailViewController
        appDetailController.appDetail.app_id = appid
        self.navigationController?.pushViewController(appDetailController, animated: true)
        
    }
}
