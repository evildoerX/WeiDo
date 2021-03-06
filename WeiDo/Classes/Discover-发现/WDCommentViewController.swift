//
//  WDCommentViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/1.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD


class WDCommentViewController: WDBaseViewController {
    
 
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
        WDLatestComments.loadTopicData(self.texttopic!.id, finished: { (hotModel, latestModel, error) in
            if error != nil
            {
                print(error)
                 SVProgressHUD.showErrorWithStatus("网络似乎有点问题")
            }
            else
            {
            //获取热评
            self.hotComments = hotModel!
            //获取最新评论
            self.latestComments = latestModel!
            self.tableView.reloadData()
            self.header.endRefreshing()
            }
        })
            
            
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
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
        view.tintColor = DFColor
    }
    

    
    
}

