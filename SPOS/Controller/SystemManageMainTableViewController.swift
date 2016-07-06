//
//  SystemManageMainTableViewController.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/6.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class SystemManageMainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        refreshingStup()
    }
    

    func refreshingStup(){
        
        if(self.refreshControl == nil){
            self.refreshControl = UIRefreshControl()
        }

        self.refreshControl?.addTarget(self, action: #selector(SystemManageMainTableViewController.refreshingData), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refreshingData(){
        self.performSelector(#selector(SystemManageMainTableViewController.timeProcess), withObject: nil, afterDelay: 0.5)
    }
    
    func timeProcess(){
        self.refreshControl?.endRefreshing()
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "数据正在加载中")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0 || section == 3){
            return 1
        }else{
            return 2
        }
    }
   

}
