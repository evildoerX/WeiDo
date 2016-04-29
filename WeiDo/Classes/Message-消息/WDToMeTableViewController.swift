//
//  WDToMeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD


class WDToMeTableViewController: WDBaseViewController {
    
    /// 数据源
    var toMeData = [WDMention]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()
 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setUpRefrshControl()
   
    }
    
    func setupTableview()
    {
  
    tableView.registerNib(UINib(nibName: "WDMessageCell", bundle: nil), forCellReuseIdentifier: WDMessageCellReuseIdentifier)
        tableView.rowHeight = 150
   
    
    }
    
    /**
     上拉刷新
     */
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in

            WDMention.loadMessageData("to_me", finished: { (models, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("好像出错啦,重新登录试试", maskType: .Black)
                }
                else
                {
                    self.toMeData = models!
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
        return toMeData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDMessageCellReuseIdentifier, forIndexPath: indexPath) as! WDMessageCell
        
        let tomeData = toMeData[indexPath.row]
   
        cell.Mention = tomeData
        return cell
    }
  
 
    

}



