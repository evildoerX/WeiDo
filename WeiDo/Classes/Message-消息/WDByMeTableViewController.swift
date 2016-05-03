//
//  WDByMeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class WDByMeTableViewController: WDBaseViewController{
    
    //数据源
    var byMe = [WDMention]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
  
    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessage(false)
        setUpRefrshControl()
        setupTableview()
 
        /**
        添加通知
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("cellClick:"), name: WDMessageCellSelected, object: nil)
       
    }
    deinit{
     NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
   func setupTableview()
   {

    tableView.registerNib(UINib(nibName: "WDMessageCell", bundle: nil), forCellReuseIdentifier: WDMessageCellReuseIdentifier)
    tableView.rowHeight = 150

    
    }
    
    func loadMessage(isNew:Bool)
    {
        
        WDMention.loadMessageData(isNew,path: "by_me") { (models, error) in
            if error != nil
            {
                print(error)
                SVProgressHUD.showErrorWithStatus("好像出错啦,重新登录试试", maskType: .Black)
            }
            else
            {
                
                self.byMe = models!
                
                self.tableView.reloadData()
                
            }
            
            
            
            
        }
        
        
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
            
            self.loadMessage(true)
            self.header.endRefreshing()
            
        })
        header.automaticallyChangeAlpha = true
        
        
        
    }
  

    // MARK: - Table view data source

  

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return byMe.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDMessageCellReuseIdentifier, forIndexPath: indexPath) as! WDMessageCell
        let byMeData =  byMe[indexPath.row]
        
        cell.Mention = byMeData
      
        return cell
    }
  
  

}



