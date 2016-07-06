//
//  SelectLanguageViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/6/20.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    let language = ["简体中文","翻體中文（臺灣）","翻體中文（香港）","English","日本語","한국어"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "选择语言"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return language.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.selectionStyle = .Default
        if(language[indexPath.row] == systemLanguage){
            cell.accessoryType = .Checkmark
            cell.setSelected(true, animated: false)
        }else {
            cell.accessoryType = .None
        }
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.text = language[indexPath.row]
        cell.tag = indexPath.row + 1
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.viewWithTag(indexPath.row + 1) as! UITableViewCell
        cell.accessoryType = .Checkmark
        systemLanguage = language[indexPath.row]
        NSUserDefaults.standardUserDefaults().setObject(systemLanguage, forKey: "SYSTEM_LANGUAGE")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
