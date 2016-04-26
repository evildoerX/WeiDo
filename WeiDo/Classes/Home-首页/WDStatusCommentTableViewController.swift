//
//  WDStatusCommentTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/21.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh


class WDStatusCommentTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    //数据源
    var statusComment = [StatusComment]()
    //顶部数据源
    var status:Status?
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  footer  */
    var footer:MJRefreshFooter{
        return (self.tableView.tableFooterView as? MJRefreshFooter)!
    }
    
    
    //传递的微博id
    var statusID:Int?
    //页码
    var page:Int = 1
    
   
    init(id: Int)
    {
     
     self.statusID = id
     super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableview()
        setupNavigation()
        setUpRefrshControl()
   
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    
    
    
    
    func setupTableview()
    {

     tableView.registerNib(UINib(nibName: "WDCommentCell", bundle: nil), forCellReuseIdentifier: WDCommentCellReuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 0, 0)
        tableView.tableFooterView = UIView()
    }
    
    
    private func setupNavigation()
    {
        
        navigationItem.title = "评论"
        self.tabBarController?.tabBar.hidden = true

        
    }
    
   
    
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            self.footer.endRefreshing()

           
        StatusComment.loadStatusComment(self.statusID!, page: 1, finished: { (models, error) in
            if error != nil
            {
            print(error)
            SVProgressHUD.showErrorWithStatus("刷新失败")
            }
            self.statusComment = models!
            self.tableView.reloadData()
            self.header.endRefreshing()
            self.page = 1
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
            StatusComment.loadStatusComment(self.statusID!, page: currentPage, finished: { (models, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("刷新失败")
                }
                self.statusComment += models!
                self.tableView.reloadData()
                self.header.endRefreshing()
                self.page = currentPage
            })
 
            
            
            
        })
        
 
      
    }


    // MARK: - Table view data source

    
 

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusComment.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCellWithIdentifier(WDCommentCellReuseIdentifier, forIndexPath: indexPath) as! WDCommentCell
        let data = self.statusComment[indexPath.row]
        cell.statusComment = data
        return cell

    }
 
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.statusComment.count == 0 ? "当前还没有评论哦" : "最新评论"
     }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return  30
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = bgColor
    }

}
