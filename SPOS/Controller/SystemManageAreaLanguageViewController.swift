//
//  SystemManageAreaLanguageViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/6/20.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

var systemArea = "中国"
var systemLanguage = "简体中文"

class SystemManageAreaLanguageViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    let tableView = UITableView.init(frame: CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地区与语言"
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        SystemManageAreaLanguageViewController.initAreaLanguage()
        
    }

    static func initAreaLanguage(){
        if let area = NSUserDefaults.standardUserDefaults().stringForKey("SYSTEM_AREA"){
            systemArea = area
        }else{
            NSUserDefaults.standardUserDefaults().setObject(systemArea, forKey: "SYSTEM_AREA")
        }
        if let language = NSUserDefaults.standardUserDefaults().stringForKey("SYSTEM_LANGUAGE"){
            systemLanguage = language
        }else{
            NSUserDefaults.standardUserDefaults().setObject(systemLanguage, forKey: "SYSTEM_LANGUAGE")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        if(indexPath.row == 0){
            cell.textLabel?.text = "选择地区"
            cell.detailTextLabel?.text = systemArea
        }else{
            cell.textLabel?.text = "选择语言"
            cell.detailTextLabel?.text = systemLanguage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            let vc = SelectAreaViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = SelectLanguageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollView.contentSize=\(scrollView.contentSize)")
        print("scrollView.contentOffset=\(scrollView.contentOffset)")
        //print("scrollView.contentInset=\(scrollView.contentInset)")
        if(scrollView.contentOffset.y > -44){
        }else{
        }
    }
    
    
}


