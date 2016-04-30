//
//  WDLoadNearByTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/16.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import AFNetworking

let NearBycellReuseIdentifier = "WDNearByCell"
class WDLoadNearByTableViewController: UITableViewController {
    /// 数据源
    var nearby = [WDNearby]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    //参数
    var params = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNearby()
        setupNavigation()
        setupTableview()
      self.tabBarController?.tabBar.hidden = true
   
    }

    
    func setupTableview()
    {
        
        tableView.contentInset = UIEdgeInsetsMake(-49 , 0, 49, 0)
        tableView.registerNib(UINib(nibName: "WDNearByCell", bundle: nil), forCellReuseIdentifier: NearBycellReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func setupNavigation()
    {
    navigationItem.title = "附近的人"

    
    }
    
    /**
     加载数据
     */
    func loadNearby()
    {
     

        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
     
            var params = [String:AnyObject]()
            params["access_token"] = userAccount.loadAccount()!.access_token!
            params["lat"] = lat!
            params["long"] = long!
            params["range"] = "3000"
            params["count"] = "30"
            params["sort"] = "1"
            
            
            let path = "https://api.weibo.com/2/place/nearby/users.json"
            
            
            AFHTTPSessionManager().GET(path, parameters: params, success: { (_, JSON) in
                
                
                self.nearby = WDNearby.LoadNearby(JSON!["users"] as! [[String:AnyObject]])
                self.tableView.reloadData()
                self.header.endRefreshing()
                }, failure: { (_, error) in
                    print(error)
                    SVProgressHUD.showErrorWithStatus("网络好像有点问题")
            })
        
        })
    
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
    }
  

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nearby.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NearBycellReuseIdentifier, forIndexPath: indexPath) as! WDNearByCell
        
        let data = nearby[indexPath.row]
       cell.nearby = data
        return cell
    }
    

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   

}
