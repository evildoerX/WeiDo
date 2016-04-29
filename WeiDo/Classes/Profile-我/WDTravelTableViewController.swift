//
//  WDTravelTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/19.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD


let TravelCellReuseIdentifier = "WDTravelCell"
let TravelBrowserWillOpen = "TravelBrowserWillOpen"
class WDTravelTableViewController: WDBaseViewController {

    //数据源
    var travel = [WDTravel]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  footer  */
    var footer:MJRefreshFooter{
        return (self.tableView.tableFooterView as? MJRefreshFooter)!
    }
    //页码
    var page:Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
       setupTableview()
        refresh()
    
   
    }
    
  
    
    func setupTableview()
    {

        title = "微游记"
       tableView.registerNib(UINib(nibName: "WDTravelCell", bundle: nil), forCellReuseIdentifier: TravelCellReuseIdentifier)
        tableView.rowHeight = 200
        
    }

    
    
    func refresh()
    {
      
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            self.footer.endRefreshing()
            WDTravel.loadTravelData(self.page, finished: { (models, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("网络似乎有点问题")
                    return
                }
                else
                {
                    self.travel = models!
                    self.tableView.reloadData()
                    self.header.endRefreshing()
                    //设置页码
                    self.page = 1
                }
            })

          
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        /**
          下拉刷新
        */
        tableView.tableFooterView = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.header.endRefreshing()
            self.footer.beginRefreshing()
            let currentPage = self.page + 1
            
            WDTravel.loadTravelData(currentPage, finished: { (models, error) in
                if error != nil
                {
                print(error)
                }
                else
                {
                 self.travel += models!
            //     self.setupTableview()
                 self.tableView.reloadData()
                 self.footer.endRefreshing()
                 self.page = currentPage
                }
            })

        
            
        })
  
    }
    
  

    // MARK: - Table view data source

  

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
               
        return self.travel.count
           }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TravelCellReuseIdentifier, forIndexPath: indexPath) as! WDTravelCell

        let data = self.travel[indexPath.row]
          cell.travel = data
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = travel[indexPath.row].bookUrl
        let vc = RxWebViewController(url: url)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
        
    }
    

}
