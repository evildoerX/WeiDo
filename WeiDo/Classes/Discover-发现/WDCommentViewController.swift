//
//  WDCommentViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/1.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import AFNetworking

let WDCommentCellReuseIdentifier = "WDCommentCell"
class WDCommentViewController: UITableViewController, UIGestureRecognizerDelegate {
    
 
    /**  header  */
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  footer  */
    var footer:MJRefreshFooter{
        return (self.tableView.tableFooterView as? MJRefreshFooter)!
    }
    /**  最热评论  */
    var hotComments = [WDLatestComments]()
    /**  最新评论  */
    var latestComments = [WDLatestComments]()
    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()
    /**  评论当前页  */
    var page = 0
    /// 数据源
    var texttopic: WDTopic?
   
    
    
    init(textTopic: WDTopic)
    {
    
        self.texttopic = textTopic
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableview()
        setUpRefrshControl()
        sweptBack()
   
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }

   
    
    /**
     获取数据
     */
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            
            let path = requestPath
            var params = [String:AnyObject]()
            params["a"] = "dataList";
            params["c"] = "comment";
            params["data_id"] = self.texttopic!.id
            params["hot"] = "1"
            
            
            self.params.setDictionary(params);
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let hotarray = JSON!["hot"] as? [[String:AnyObject]]
                let dataarray = JSON!["data"] as? [[String:AnyObject]]
                //获取最热评论
                self.hotComments = WDLatestComments.LoadLatestComments(hotarray!)
                //获取最新评论
                self.latestComments = WDLatestComments.LoadLatestComments(dataarray!)
                
                self.tableView.reloadData()
                self.header.endRefreshing()
                
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
        
        
    }

  
    func setupTableview()
    {
        tableView.registerNib(UINib(nibName: "WDCommentCell", bundle: nil), forCellReuseIdentifier: WDCommentCellReuseIdentifier)
         tableView.registerNib(UINib(nibName: "WMWordToipCell", bundle: nil), forCellReuseIdentifier: TextCellReuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        tableView.tableFooterView = UIView()
   
    
    }
    
    
  private func setupNavigation()
  {
   
    navigationItem.title = "评论"
    self.tabBarController?.tabBar.hidden = true


    }
    
    func back()
    {
     dismissViewControllerAnimated(true, completion: nil)
    }
   
    /**
     滑动返回
     */
    func sweptBack()
    {
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: "handleNavigationTransition:")
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        
    }
    /**
     判断是否滑动返回
     */
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1
        {
            return false
        }
        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.hotComments.count > 0{
            return 3
        } else if self.latestComments.count > 0{
            return 2
        } else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }else if section == 1{
            return self.hotComments.count > 0 ? self.hotComments.count : self.latestComments.count
        }else{
            return self.latestComments.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
         
            let cell = tableView.dequeueReusableCellWithIdentifier(TextCellReuseIdentifier, forIndexPath: indexPath) as! WMWordToipCell
         //   let cell = WMWordToipCell.topicCell()
      
            cell.wordTopic = texttopic
     
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(WDCommentCellReuseIdentifier, forIndexPath: indexPath) as! WDCommentCell
           
            cell.comment = getComments(indexPath)
            return cell
            
        }
    }
    
    
    func getComments(indexPath:NSIndexPath) -> WDLatestComments{
        
        var comment:WDLatestComments?
        
        if indexPath.section == 1{
            comment = hotComments.count > 0 ? hotComments[indexPath.row] : latestComments[indexPath.row]
        }else{
           
            comment = latestComments[indexPath.row]
        }
        return comment!
        
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return self.hotComments.count > 0 ? "最热评论" : "最新评论"
        }else if section == 2{
            return "最新评论"
        }else{
            return nil
        }
    }
    
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
                return UITableViewAutomaticDimension
        }
    
        override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return section == 0 ? 0 : 30
        }
    /**
     设置header样式
     */
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = bgcolor
    }
    

    
    
}

