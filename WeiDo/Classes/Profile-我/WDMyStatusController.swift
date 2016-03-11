//
//  WDMyStatusController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

let WDMyStatusCellReuseIdentifier = "WDMyStatusCell"
class WDMyStatusController: UITableViewController, UIGestureRecognizerDelegate {
    /// 数据源
    var mineStatus = [WDMineStatus]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
     setupNavigation()
    setupTableView()
     setUpRefrshControl()
        tableView.reloadData()
        
    }

    func setupTableView()
    {
     tableView.contentInset = UIEdgeInsetsMake(-49 , 0, 49, 0)
            tableView.registerNib(UINib(nibName: "WDMyStatusCell", bundle: nil), forCellReuseIdentifier: WDMyStatusCellReuseIdentifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.userInteractionEnabled = true

    }
    
    
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            
            let path = "https://api.weibo.com/2/statuses/user_timeline.json"
            let params = ["access_token": userAccount.loadAccount()!.access_token!]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let myStatusarray = JSON!["statuses"] as! [[String:AnyObject]]
                
                self.mineStatus = WDMineStatus.LoadMine(myStatusarray)
                self.tableView.reloadData()
                self.header.endRefreshing()
                
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
    
    
    }
    
    
 func setupNavigation()
    {
        navigationItem.title = "我的微博"
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
    
    
    }
    
    
    func back()
    {
     dismissViewControllerAnimated(true, completion: nil)
    }

 
    
    // MARK: - Table view data source

    
   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mineStatus.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDMyStatusCellReuseIdentifier, forIndexPath: indexPath) as! WDMyStatusCell
        let myStatuesCell = mineStatus[indexPath.row]
        cell.mineStatus = myStatuesCell
        return cell
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
  
}
