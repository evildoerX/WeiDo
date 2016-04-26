//
//  WDTextTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/27.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

let TextCellReuseIdentifier = "WMWordToipCell"
class WDTextTableViewController: UITableViewController {
    
    //数据源
    var topics =  [WDTopic]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  footer  */
    var footer:MJRefreshFooter{
        return (self.tableView.tableFooterView as? MJRefreshFooter)!
    }
    /**  当前页  */
    var page = 1
    /**  请求下一页需要的参数  */
    var maxtime = ""

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
      
        setUpRefrshControl()
        
        /**
        添加通知
        */
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDTextTableViewController.wordShare(_:)), name: WDWordShare, object: nil)
   
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
   func setupTableView(){
    
    tableView.scrollIndicatorInsets = self.tableView.contentInset
    tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
    
    tableView.registerNib(UINib(nibName: "WMWordToipCell", bundle: nil), forCellReuseIdentifier: TextCellReuseIdentifier)
    tableView.rowHeight = 200
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //打开分享
    func wordShare(notify:NSNotification)
    {
        
        guard let message = notify.userInfo![WDWordShare] as? String  else
        {
            return
        }
        //1是文本
        let vc = WDShareViewController(type: 1, text: message, url: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
    }
    
    /**
     设置上下拉刷新
     */
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
      tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
      self.footer.endRefreshing()
        WDTopic.loadTopicData("29",maxtime: "",page: 0 , finished: { (models, maxtime, error) in
            if error != nil
            {
            print(error)
            SVProgressHUD.showErrorWithStatus("刷新失败")
            }
            self.maxtime = maxtime!
            self.topics = models!
            self.page = 0
            self.tableView.reloadData()
            self.header.endRefreshing()
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
            let currentpage = self.page + 1
            WDTopic.loadTopicData("29", maxtime: self.maxtime, page: currentpage, finished: { (models, maxtime, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("刷新失败")
                }
                else
                {
                self.maxtime = maxtime!
                self.topics += models!
                self.page = currentpage
                self.tableView.reloadData()
                self.footer.endRefreshing()
                }
            })
            
            
            
        })
       
        
    }
  

       // MARK - tableview delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return self.topics.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCellWithIdentifier(TextCellReuseIdentifier, forIndexPath: indexPath) as! WMWordToipCell
        let wordTopic = topics[indexPath.row]
        
        cell.wordTopic = wordTopic
        
    

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let topic = topics[indexPath.row]
        let vc = WDCommentViewController(textTopic: topic)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let wordTopic = topics[indexPath.row]
        if let height = rowCache[wordTopic.id]
        {
         return height
        }
        
        let height = UITableViewAutomaticDimension
        rowCache[wordTopic.id] = height
        return height

    }

    
    /// 行高的缓存, 利用字典作为容器. key就是的id, 值就是对应的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
}


