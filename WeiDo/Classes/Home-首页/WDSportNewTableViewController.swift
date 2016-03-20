//
//  WDSportNewTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

let WDNewCellReuseIdentifier = "WDNewsCell"
let WDSportNewsWillOpen = "WDSportNewsWillOpen"
let newsParams = ["key":"28874a32bce9a4b984c57c3538e68809","num":20]

class WDSportNewTableViewController: UITableViewController {

    /// 数据源
    var sportNew = [WDNews]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        loadNews()
       
        //添加通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openBrowser:", name: WDSportNewsWillOpen, object: nil)
    }
    
    deinit{
     NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setupNavigation()
    {
        navigationItem.title = "体育新闻"
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBackBarButtonItem(self, action: "back")
    
    }
    
    func setupTableView()
    {
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        tableView.rowHeight = 200
      tableView.registerNib(UINib(nibName: "WDNewsCell", bundle: nil), forCellReuseIdentifier: WDNewCellReuseIdentifier)
    
    }
    /**
     加载新闻
     */
    func  loadNews()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            let path = "http://api.huceo.com/tiyu/"
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: newsParams, progress: nil, success: { (_, JSON) -> Void in
              
                let sportarray = JSON!["newslist"] as! [[String:AnyObject]]
               self.sportNew =  WDNews.LoadNews(sportarray)
                
                 self.tableView.reloadData()
                self.header.endRefreshing()
                
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
     
    }
    /**
     打开网页
     */
    func openBrowser(notify: NSNotification)
    {
        guard let urls = notify.userInfo![WDSportNewsWillOpen] as? String else
        {
            return
        }
        print(urls)
        let url = NSURL(string: urls)
        let vc = RxWebViewController(url: url)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func back()
    {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sportNew.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDNewCellReuseIdentifier, forIndexPath: indexPath) as! WDNewsCell
        let data = sportNew[indexPath.row]
        cell.sportnew = data
        return cell
       
    }

   
    

}
