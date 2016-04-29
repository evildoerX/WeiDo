//
//  WDTechnologyNewsViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

let WDTechnologyNewsWillOpen = "WDTechnologyNewsWillOpen"

class WDTechnologyNewsViewController: UITableViewController {

    /// 数据源
    var technologyNew = [WDNews]()
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
        
        navigationItem.title = "科技新闻"
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        
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
            WDNews.loadNewsData("keji", finished: { (models, error) in
                if error != nil
                {
                    print(error)
                     SVProgressHUD.showErrorWithStatus("刷新失败", maskType: .Black)
                }
                else
                {
                    self.technologyNew = models!
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
        return self.technologyNew.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDNewCellReuseIdentifier, forIndexPath: indexPath) as! WDNewsCell
        let data = technologyNew[indexPath.row]
        cell.technologynew = data
        return cell

      }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlStr = technologyNew[indexPath.row].url
        let url = NSURL(string: urlStr!)
        let vc = RxWebViewController(url: url)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
    

}
