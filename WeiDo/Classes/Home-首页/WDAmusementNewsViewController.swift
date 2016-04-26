
//
//  WDAmusementNewsViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

let WDAmusementNewsWillOpen = "WDAmusementNewsWillOpen"
class WDAmusementNewsViewController: UITableViewController {

    /// 数据源
    var amusementNew = [WDNews]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
        loadNews()
        
  
    }
 
    func setupNavigation()
    {
        navigationItem.title = "娱乐新闻"
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WDAmusementNewsViewController.back))
        
    }

    func setupTableView()
    {
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
         tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "WDNewsCell", bundle: nil), forCellReuseIdentifier: WDNewCellReuseIdentifier)
        
    }
    
    func  loadNews()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            WDNews.loadNewsData("huabian", finished: { (models, error) in
                if error != nil
                {
                    print(error)
                     SVProgressHUD.showErrorWithStatus("刷新失败", maskType: .Black)
                }
                else
                {
                    self.amusementNew = models!
                    self.tableView.reloadData()
                    self.header.endRefreshing()
                }
            })
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
        
    }

    func back()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.amusementNew.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(WDNewCellReuseIdentifier, forIndexPath: indexPath) as! WDNewsCell
        let data = amusementNew[indexPath.row]
        cell.amusementnew = data
        return cell

      
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlStr = amusementNew[indexPath.row].url
        let url = NSURL(string: urlStr!)
        let vc = RxWebViewController(url: url)
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
    


  
}
