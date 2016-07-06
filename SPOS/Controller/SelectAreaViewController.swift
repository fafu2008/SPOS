//
//  SelectAreaViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/6/20.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SelectAreaViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{

    let area = ["中国","中国（台湾）","中国（香港）","日本","韩国"]
    var flag:NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "选择地区"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return area.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.selectionStyle = .Default
        if(area[indexPath.row] == systemArea){
            cell.accessoryType = .Checkmark
            cell.setSelected(true, animated: false)
            flag = indexPath
        }else {
            cell.accessoryType = .None
        }
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.text = area[indexPath.row]
        cell.tag = indexPath.row + 1
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.viewWithTag(indexPath.row + 1) as! UITableViewCell
        cell.accessoryType = .Checkmark
        systemArea = area[indexPath.row]
        NSUserDefaults.standardUserDefaults().setObject(systemArea, forKey: "SYSTEM_AREA")
        NSUserDefaults.standardUserDefaults().synchronize()
//        if(cell.accessoryType == .None){
//            cell.accessoryType = .Checkmark
//        }
        let tempcell = tableView.cellForRowAtIndexPath(flag)
        tempcell!.accessoryType = .None
        //tableView.reloadRowsAtIndexPaths([indexPath,flag], withRowAnimation: UITableViewRowAnimation.Fade)
        flag = indexPath

        tableView.reloadData()
        //self.navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        //self.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
        return indexPath
    }
//    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
//        return indexPath
//    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)

        let cell = tableView.viewWithTag(indexPath.row + 1) as! UITableViewCell
        if(cell.accessoryType == .Checkmark){
            cell.accessoryType = .None
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    

}
