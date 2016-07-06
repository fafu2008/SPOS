//
//  VersionManageViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/10.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class VersionManageViewController: UIViewController, UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phoneNuberClicked(sender: UIButton) {
        let url1 = NSURL(string: "tel://400-600-1612")
        UIApplication.sharedApplication().openURL(url1!)
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()

        
    }
    
    
    //http://www.jianshu.com/p/e05e2a93907b
    
    var currentVersion:NSString?
    
    var recervedData:NSMutableData?
    
    func dealVersion(sender:AnyObject){
        recervedData = NSMutableData()
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        currentVersion = infoDict.objectForKey("CFBundleShortVersionString") as! String
        print("currentVersion = \(currentVersion)")
        var stringURL = "http://itunes.apple.com/search?term=软件名称&entity=software"
        //如果程序中有非英文名称，需要转码
        stringURL=stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let URL = NSURL(string: stringURL)
        let request = NSURLRequest(URL: URL!)
        NSURLConnection(request: request, delegate: self)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        recervedData?.length = 0
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        recervedData?.appendData(data)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        do{
        
        let dic:NSDictionary? = try NSJSONSerialization.JSONObjectWithData(recervedData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        
        let infoArray : NSArray? = dic?.objectForKey("results") as? NSArray
        
        if infoArray?.count != 0 {
            let releaseInfo : NSDictionary = infoArray?.objectAtIndex(0) as! NSDictionary
            let lastVersion : NSString = releaseInfo.objectForKey("version") as! NSString
            print("lastVersion = \(lastVersion)")
            
            if (currentVersion?.floatValue < lastVersion.floatValue){
                
                let alertView = UIAlertView(title: "更新", message: "有新版本更新，是否前往更新？", delegate: self, cancelButtonTitle: "关闭", otherButtonTitles: "更新")
                
                alertView.tag = 10000
                
                alertView.show()
                
            }
                
            else{
                
                let alertView = UIAlertView(title: "更新", message: "此版本为最新版本", delegate: self, cancelButtonTitle: "确定")
                
                alertView.tag = 10001
                
                alertView.show()
                
            }
            
        }
        }catch{
            
        }

        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 10000{
            
            if buttonIndex == 1 {
                
                var url = NSURL(string: "跳转到iTunes里面你需要更新的软件的地址")
                
                UIApplication.sharedApplication().openURL(url!)
                
            }
            
        }
        
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