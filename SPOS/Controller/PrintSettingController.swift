//
//  PrintSettingController.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/29.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class PrintSettingController: UITableViewController {
    
    
    var titles = [" 打印方式" , "交易后立刻打印" , "打印联数" , "打印纸尺寸" , "底部备注"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: -Action
    func isFinishedAndStartPrinting(sender : AnyObject) {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = titles[indexPath.row]
        
        switch indexPath.row {
        case 0 , 2 , 3:
            cell.accessoryType = .DisclosureIndicator
            cell.accessoryView = nil
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = nil
            }else if indexPath.row == 2 {
                cell.detailTextLabel?.text = "2联"
            }else{
                cell.detailTextLabel?.text = "58mm"
            }
        case 1:
            cell.detailTextLabel?.text = nil
            let switchPrinter = UISwitch()
            switchPrinter.addTarget(self, action: #selector(PrintSettingController.isFinishedAndStartPrinting(_:)), forControlEvents: .ValueChanged)
            cell.accessoryView = switchPrinter
        case 4:
            cell.detailTextLabel?.text = nil
            let tvRemark = UITextView()
            tvRemark.text = "小票底部内容，限30字"
            tvRemark.bounds = CGRectMake(0, 0, SCREENWIDTH/2, 40)
            cell.accessoryView = tvRemark
        default:
            cell.detailTextLabel?.text = nil
            cell.accessoryView = nil
            cell.accessoryType = .None
        }
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
