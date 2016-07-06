//
//  AppsWebViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/27.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit


class AppsWebViewController: UIViewController ,UIWebViewDelegate{

    var webView: UIWebView!
    
    var app_name:String = ""
    
    var request_url:String = ""

    private let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRectMake(0, 0,SCREENWIDTH , 3))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stupSubViews()
        
        webView.delegate = self
        if(request_url.isEmpty == false){
            webView.loadRequest(NSURLRequest(URL: NSURL(string: request_url)!))
        }else{
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.tlinx.cn")!))
        }
        // Do any additional setup after loading the view.
    }

    static var onShow = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        AppsWebViewController.onShow = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        AppsWebViewController.onShow = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func stupTitle(){
        
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 30, width: 40, height: 20))
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(AppsWebViewController.backButtonClicked), forControlEvents: .TouchUpInside)
        let leftItemback = UIBarButtonItem(customView: backButton)
        
        let closeButton = UIButton(frame: CGRect(x: 40, y: 30, width: 50, height: 20))
        closeButton.setTitle("关闭", forState: .Normal)
        closeButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.addTarget(self, action: #selector(AppsWebViewController.closeButtonClicked), forControlEvents: .TouchUpInside)
        let leftItemClose = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItems = [leftItemback,leftItemClose]
        
        let titleLabel = UILabel(frame: CGRect(x: (SCREENWIDTH - 150) / 2, y: 30, width: 150, height: 20))
        titleLabel.text = app_name
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textAlignment = .Center
        
        self.navigationItem.titleView = titleLabel
        
        webView = UIWebView(frame: CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 60))
        view.addSubview(webView)

    }
    
    override func prefersStatusBarHidden() ->Bool{
        return true
    }
    
    
    func stupSubViews(){
        
        self.navigationController?.navigationBar.hidden = true
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 60))
       
        let backButton = UIButton(frame: CGRect(x: 0, y: 30, width: 40, height: 20))
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(AppsWebViewController.backButtonClicked), forControlEvents: .TouchUpInside)
        titleView.addSubview(backButton)
       
        let closeButton = UIButton(frame: CGRect(x: 40, y: 30, width: 50, height: 20))
        closeButton.setTitle("关闭", forState: .Normal)
        closeButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.addTarget(self, action: #selector(AppsWebViewController.closeButtonClicked), forControlEvents: .TouchUpInside)
        titleView.addSubview(closeButton)
        
        let titleLabel = UILabel(frame: CGRect(x: (SCREENWIDTH - 150) / 2, y: 30, width: 150, height: 20))
        titleLabel.text = app_name
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textAlignment = .Center
        titleView.addSubview(titleLabel)
        
        view.addSubview(titleView)
        titleView.backgroundColor = UIColor.init(colorLiteralRed: 50/255, green: 150/255, blue: 238/255, alpha: 1.0)
        webView = UIWebView(frame: CGRect(x: 0, y: 60, width: SCREENWIDTH, height: SCREENHEIGHT - 60))
        webView.addSubview(loadProgressAnimationView)
        view.addSubview(webView)
        
    }
    
    
    func closeButtonClicked(){
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func backButtonClicked(){
        if(webView.canGoBack == true){
            webView.goBack()
        }else{
            self.navigationController?.navigationBar.hidden = false
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        _ = request.URL?.absoluteString
        
        return true
        
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        loadProgressAnimationView.startLoadProgressAnimation()
    }
    func webViewDidFinishLoad(webView: UIWebView){
        loadProgressAnimationView.endLoadProgressAnimation()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        
    }
    
    
    
}
