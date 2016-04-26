//
//  WDLoadNearByTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/16.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

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

            
            WDNearby.loadNearByData({ (models, error) in
                if error != nil
                {
                print(error)
                }
                else
                {
                self.nearby = models!
                self.tableView.reloadData()
                self.header.endRefreshing()
                }
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
